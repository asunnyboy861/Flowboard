import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.dueDate, ascending: true)],
        predicate: NSPredicate(format: "dueDate != nil"),
        animation: .default
    )
    private var cards: FetchedResults<Card>

    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()

                Divider()

                List(cardsForSelectedDate) { card in
                    NavigationLink(destination: CardDetailView(card: card)) {
                        HStack {
                            PriorityBadge(priority: card.priority)
                            VStack(alignment: .leading) {
                                Text(card.title ?? "Untitled")
                                    .font(.subheadline)
                                    .strikethrough(card.isCompleted)
                                if let columnName = card.column?.name {
                                    Text(columnName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            if card.isOverdue {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }

    private var cardsForSelectedDate: [Card] {
        let start = Calendar.current.startOfDay(for: selectedDate)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        return cards.filter { card in
            guard let due = card.dueDate else { return false }
            return due >= start && due < end
        }
    }
}
