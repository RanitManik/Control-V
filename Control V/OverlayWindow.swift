import AppKit
import SwiftUI

final class OverlayWindow {
    private var window: NSWindow?

    func toggle() {
        if window == nil { createWindow() }
        guard let w = window else { return }
        if w.isVisible { w.orderOut(nil) } else { show() }
    }

    private func createWindow() {
        let content = OverlayRootView()
        let vc = NSHostingController(rootView: content)
        let w = NSWindow(contentViewController: vc)
        w.styleMask = [.fullSizeContentView, .titled, .closable]
        w.isReleasedWhenClosed = false
        w.titleVisibility = .hidden
        w.titlebarAppearsTransparent = true
        w.isOpaque = false
        w.backgroundColor = .clear
        w.level = .statusBar
        w.setFrame(NSRect(x: 0, y: 0, width: 700, height: 480), display: false)
        window = w
    }

    private func show() {
        guard let w = window, let screen = NSScreen.main else { return }
        let rect = screen.visibleFrame
        let size = w.frame.size
        let frame = NSRect(
            x: rect.midX - size.width / 2,
            y: rect.midY - size.height / 2,
            width: size.width,
            height: size.height
        )
        w.setFrame(frame, display: true)
        w.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
