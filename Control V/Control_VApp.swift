import AppKit
import SwiftUI

@main
struct ControlVApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Control V", systemImage: "doc.on.clipboard") {
            MenuPopoverView()
                .frame(width: 420, height: 520)
        }
        .menuBarExtraStyle(.window)

        Settings { SettingsView() }
    }
}
