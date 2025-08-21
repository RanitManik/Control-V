import AppKit

enum ClipPayload: Equatable {
    case text(String)
    case url(URL)
    case image(NSImage)
}

struct ClipItem: Identifiable, Equatable {
    let id = UUID()
    let date = Date()
    let payload: ClipPayload

    init(payload: ClipPayload) { self.payload = payload }

    static func == (lhs: ClipItem, rhs: ClipItem) -> Bool {
        switch (lhs.payload, rhs.payload) {
        case (.text(let a), .text(let b)): return a == b
        case (.url(let a), .url(let b)): return a == b
        case (.image(let a), .image(let b)):
            return a.tiffRepresentation == b.tiffRepresentation
        default: return false
        }
    }

    var primaryText: String {
        switch payload {
        case .text(let s): return s
        case .url(let u): return u.absoluteString
        case .image: return "Image"
        }
    }

    var subtitle: String {
        let r = RelativeDateTimeFormatter()
        r.unitsStyle = .short
        return r.localizedString(for: date, relativeTo: Date())
    }

    // ✅ Added so ClipboardRow compiles
    var previewText: String {
        switch payload {
        case .text(let s):
            return s.count > 80 ? String(s.prefix(80)) + "…" : s
        case .url(let u):
            return u.absoluteString
        case .image:
            return "📸 Image"
        }
    }
}
