import SwiftUI

struct PriorityBadge: View {
    let priority: Int16

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }

    private var color: Color {
        switch priority {
        case 3: return .red
        case 2: return .orange
        case 1: return .yellow
        default: return .gray
        }
    }
}
