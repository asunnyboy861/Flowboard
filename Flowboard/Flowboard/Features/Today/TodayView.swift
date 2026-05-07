import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.priority, ascending: false)],
        predicate: NSPredicate(format: "isCompleted == NO AND (dueDate == nil OR dueDate <= %@)", Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as NSDate),
        animation: .default
    )
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationStack {
            List {
                if cards.isEmpty {
                    ContentUnavailableView(
                        "All caught up!",
                        systemImage: "checkmark.circle",
                        description: Text("No tasks due today. Enjoy your day!")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(cards) { card in
                        NavigationLink(destination: CardDetailView(card: card)) {
                            TodayCardRow(card: card)
                        }
                    }
                }
            }
            .navigationTitle("Today")
        }
    }
}

struct TodayCardRow: View {
    @ObservedObject var card: Card
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        HStack {
            Button(action: toggleComplete) {
                Image(systemName: card.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(card.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title ?? "Untitled")
                    .font(.subheadline)
                    .foregroundStyle(card.isCompleted ? .secondary : .primary)
                    .strikethrough(card.isCompleted)

                HStack {
                    if let boardName = card.column?.board?.name {
                        Label(boardName, systemImage: "square.grid.2x2")
                    }
                    if let columnName = card.column?.name {
                        Text("· \(columnName)")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            PriorityBadge(priority: card.priority)
        }
        .padding(.vertical, 2)
    }

    private func toggleComplete() {
        let repo = CardRepository(context: viewContext)
        do {
            try repo.updateCard(card, isCompleted: !card.isCompleted)
        } catch {
            print("Failed to toggle: \(error)")
        }
    }
}
