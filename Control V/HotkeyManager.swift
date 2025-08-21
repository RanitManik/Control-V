import AppKit
import Carbon.HIToolbox

final class HotkeyManager {
    static let shared = HotkeyManager()

    private var hotKeyRef: EventHotKeyRef?
    private var callback: (() -> Void)?

    func registerHotkey(
        modifiers: NSEvent.ModifierFlags,
        key: Int,
        _ action: @escaping () -> Void
    ) {
        callback = action

        let carbonModifiers = modifiersToCarbon(modifiers)
        let hotKeyID = EventHotKeyID(
            signature: OSType("CVHK".fourCharCodeValue),
            id: 1
        )

        // Define event type properly
        let eventType = [
            EventTypeSpec(
                eventClass: OSType(kEventClassKeyboard),
                eventKind: UInt32(kEventHotKeyPressed)
            )
        ]

        // Install handler
        InstallEventHandler(
            GetEventDispatcherTarget(),
            { (_, _, userData) -> OSStatus in
                guard let userData = userData else { return noErr }
                let hotKeyManager = Unmanaged<HotkeyManager>
                    .fromOpaque(userData)
                    .takeUnretainedValue()
                hotKeyManager.callback?()
                return noErr
            },
            1,
            eventType,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            nil
        )

        // Register hotkey
        RegisterEventHotKey(
            UInt32(key),
            carbonModifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &hotKeyRef
        )
    }

    private func modifiersToCarbon(_ flags: NSEvent.ModifierFlags) -> UInt32 {
        var carbon: UInt32 = 0
        if flags.contains(.command) { carbon |= UInt32(cmdKey) }
        if flags.contains(.shift) { carbon |= UInt32(shiftKey) }
        if flags.contains(.option) { carbon |= UInt32(optionKey) }
        if flags.contains(.control) { carbon |= UInt32(controlKey) }
        return carbon
    }
}

extension String {
    fileprivate var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        if let data = self.data(using: .macOSRoman) {
            for i in 0..<min(4, data.count) {
                result = (result << 8) + FourCharCode(data[i])
            }
        }
        return result
    }
}
