import SwiftUI

struct SettingsView: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("maxHistory") private var maxHistory = 50

    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Launch at Login", isOn: $launchAtLogin)

                Stepper(value: $maxHistory, in: 10...500, step: 10) {
                    Text("Max History: \(maxHistory)")
                }
            }

            Section(header: Text("About")) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Control V")
                        .font(.headline)
                    Text("A modern clipboard manager for macOS.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(20)
        .frame(width: 400, height: 250)
    }
}

#Preview {
    SettingsView()
}
