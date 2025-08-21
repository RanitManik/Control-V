import SwiftUI

// A new, smaller view for the list
struct ClipItemsListView: View {
    let items: [ClipItem]
    let pasteAction: (ClipItem) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(items) { item in
                    Button(action: { pasteAction(item) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.primaryText)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(item.previewText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(
                                .ultraThinMaterial
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// Then, update OverlayRootView to use the new subview
struct OverlayRootView: View {
    @ObservedObject var manager = ClipboardManager.shared
    @State private var query = ""

    private var filtered: [ClipItem] {
        if query.isEmpty { return manager.items }
        return manager.items.filter {
            $0.primaryText.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ZStack {
            VisualEffectBlur(
                material: .underWindowBackground,
                blendingMode: .behindWindow
            )
            .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .padding(6)

            VStack(spacing: 12) {
                // Header
                HStack(spacing: 8) {
                    Image(systemName: "command")
                        .foregroundStyle(.secondary)
                    Text("Control V")
                        .font(.headline)
                    Spacer()
                    Text("⌘⇧V to toggle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Search Bar
                TextField("Search…", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // The corrected line with the closure fix
                ClipItemsListView(items: filtered) { item in
                    manager.paste(item, asPlain: false)
                }
                .frame(maxHeight: 400)

                // Footer
                HStack {
                    Button("Clear All") {
                        manager.clear()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)

                    Spacer()

                    Text("\(filtered.count) items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding([.horizontal, .bottom])
            }
            .padding(.top)
        }
    }
}
