import SwiftUI

struct TagChip: View {
    let name: String
    let colorHex: String

    var body: some View {
        Text("#\(name)")
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: colorHex).opacity(0.2))
            .foregroundStyle(Color(hex: colorHex))
            .clipShape(Capsule())
    }
}
