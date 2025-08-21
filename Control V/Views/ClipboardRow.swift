import SwiftUI

struct ClipboardRow: View {
    let item: ClipItem
    let onTap: (ClipItem) -> Void

    var body: some View {
        Button(action: { onTap(item) }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.primaryText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(item.previewText)  // Use previewText instead of optional secondaryText
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(.plain)
    }
}
