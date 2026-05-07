import SwiftUI
import CoreData

struct BoardView: View {
    @ObservedObject var board: Board
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddCard = false
    @State private var newCardText = ""
    @State private var selectedColumn: Column?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(board.columnsArray) { column in
                    ColumnView(column: column, onAddCard: {
                        selectedColumn = column
                        showingAddCard = true
                    })
                    .frame(width: 280)
                }

                AddColumnButton(board: board)
            }
            .padding()
        }
        .navigationTitle(board.name ?? "Board")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add Task", isPresented: $showingAddCard) {
            TextField("Task title or natural language", text: $newCardText)
            Button("Add") { addCard() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Type a task title or use natural language (e.g., 'Call client tomorrow !! #urgent')")
        }
    }

    private func addCard() {
        guard !newCardText.isEmpty, let column = selectedColumn else { return }
        let parsed = NaturalLanguageParser.parse(newCardText)
        let repo = CardRepository(context: viewContext)
        do {
            _ = try repo.createCard(
                title: parsed.title,
                in: column,
                priority: parsed.priority,
                dueDate: parsed.dueDate
            )
            newCardText = ""
        } catch {
            print("Failed to add card: \(error)")
        }
    }
}

struct AddColumnButton: View {
    let board: Board
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddColumn = false
    @State private var newColumnName = ""

    var body: some View {
        VStack {
            Button(action: { showingAddColumn = true }) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 44)
                    .overlay {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Column")
                        }
                        .foregroundStyle(.secondary)
                    }
            }
        }
        .alert("Add Column", isPresented: $showingAddColumn) {
            TextField("Column name", text: $newColumnName)
            Button("Add") {
                guard !newColumnName.isEmpty else { return }
                let repo = ColumnRepository(context: viewContext)
                do {
                    _ = try repo.addColumn(name: newColumnName, to: board)
                    newColumnName = ""
                } catch {
                    print("Failed to add column: \(error)")
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
