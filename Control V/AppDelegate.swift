import AppKit
import Carbon.HIToolbox

final class AppDelegate: NSObject, NSApplicationDelegate {
    let overlay = OverlayWindow()

    func applicationDidFinishLaunching(_ notification: Notification) {
        ClipboardManager.shared.start()
        HotkeyManager.shared.registerHotkey(
            modifiers: [.command, .shift],
            key: kVK_ANSI_V
        ) { [weak self] in
            self?.overlay.toggle()
        }
    }
}
