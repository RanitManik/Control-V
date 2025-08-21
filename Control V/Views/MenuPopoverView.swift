import SwiftUI

struct MenuPopoverView: View {
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
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)

            VStack(spacing: 10) {
                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search…", text: $query)
                        .textFieldStyle(.plain)
                }
                .padding(10)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 12)
                )
                .padding(.horizontal)

                // Clipboard list
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(filtered) { clip in
                            ClipboardRow(item: clip) { item in
                                ClipboardManager.shared.paste(
                                    item,
                                    asPlain: false
                                )
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                }
            }
            .padding(12)
        }
    }
}
