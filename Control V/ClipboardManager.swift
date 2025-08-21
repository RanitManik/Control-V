import AppKit
import Combine

final class ClipboardManager: ObservableObject {
    static let shared = ClipboardManager()

    @Published private(set) var items: [ClipItem] = []

    private let pb = NSPasteboard.general
    private var lastChange = -1
    private var timer: Timer?
    private let maxItems = 300

    func start() {
        lastChange = pb.changeCount
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) {
            [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard pb.changeCount != lastChange else { return }
        lastChange = pb.changeCount

        // Respect privacy hints
        let types = pb.types ?? []
        if types.contains(
            NSPasteboard.PasteboardType("org.nspasteboard.TransientType")
        )
            || types.contains(
                NSPasteboard.PasteboardType("org.nspasteboard.ConcealedType")
            )
        {
            return
        }

        guard let item = pb.pasteboardItems?.first else { return }

        if let str = item.string(forType: .string),
            !str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            push(.text(str))
            return
        }
        if let urlString = item.string(forType: .URL),
            let url = URL(string: urlString)
        {
            push(.url(url))
            return
        }
        if let tiff = item.data(forType: .tiff), let img = NSImage(data: tiff) {
            push(.image(img))
            return
        }
    }

    private func push(_ payload: ClipPayload) {
        let model = ClipItem(payload: payload)
        if items.first == model { return }  // de-dup sequential
        items.insert(model, at: 0)
        if items.count > maxItems { items.removeLast(items.count - maxItems) }
    }

    func paste(_ item: ClipItem, asPlain: Bool) {
        let pb = NSPasteboard.general
        pb.clearContents()
        switch item.payload {
        case .text(let s):
            let content = asPlain ? s : s
            pb.setString(content, forType: .string)
        case .url(let u):
            pb.setString(u.absoluteString, forType: .string)
        case .image(let img):
            guard let tiff = img.tiffRepresentation else { return }
            pb.setData(tiff, forType: .tiff)
        }
        AutoPaste.tryCommandV()
    }

    func clear() {
        items.removeAll()
    }
}

enum AutoPaste {
    static func tryCommandV() {
        // Requires Accessibility permission; if not granted, nothing happens.
        let script =
            "tell application \"System Events\" to keystroke \"v\" using {command down}"
        NSAppleScript(source: script)?.executeAndReturnError(nil)
    }
}
