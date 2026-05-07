import SwiftUI
import CoreData

struct CardRowView: View {
    @ObservedObject var card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                PriorityBadge(priority: card.priority)

                Text(card.title ?? "Untitled")
                    .font(.subheadline)
                    .foregroundStyle(card.isCompleted ? .secondary : .primary)
                    .strikethrough(card.isCompleted)

                Spacer()
            }

            if card.dueDate != nil {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(dueDateString)
                        .font(.caption2)
                }
                .foregroundStyle(card.isOverdue ? .red : .secondary)
            }

            if !card.tagsArray.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(card.tagsArray, id: \.id) { tag in
                            TagChip(name: tag.name ?? "", colorHex: tag.colorHex ?? "#8E8E93")
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }

    private var dueDateString: String {
        guard let due = card.dueDate else { return "" }
        if due.isToday { return "Today" }
        if due.isTomorrow { return "Tomorrow" }
        return due.formattedShort
    }
}
