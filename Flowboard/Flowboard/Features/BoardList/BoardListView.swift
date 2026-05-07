import SwiftUI
import CoreData

struct BoardListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Board.updatedAt, ascending: false)],
        animation: .default
    )
    private var boards: FetchedResults<Board>

    @State private var showingCreateBoard = false
    @State private var newBoardName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(boards) { board in
                    NavigationLink(destination: BoardView(board: board)) {
                        BoardRowView(board: board)
                    }
                }
                .onDelete(perform: deleteBoards)
            }
            .navigationTitle("Flowboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingCreateBoard = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Board", isPresented: $showingCreateBoard) {
                TextField("Board name", text: $newBoardName)
                Button("Create") {
                    createBoard()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a name for your new board")
            }
        }
    }

    private func createBoard() {
        guard !newBoardName.isEmpty else { return }
        let repo = BoardRepository(context: viewContext)
        do {
            _ = try repo.createBoard(name: newBoardName)
            newBoardName = ""
        } catch {
            print("Failed to create board: \(error)")
        }
    }

    private func deleteBoards(offsets: IndexSet) {
        for index in offsets {
            let board = boards[index]
            let repo = BoardRepository(context: viewContext)
            do {
                try repo.deleteBoard(board)
            } catch {
                print("Failed to delete board: \(error)")
            }
        }
    }
}

struct BoardRowView: View {
    let board: Board

    var body: some View {
        HStack {
            Image(systemName: board.icon ?? "folder")
                .foregroundStyle(Color(hex: board.colorHex ?? "#4A90D9"))
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(board.name ?? "Untitled")
                    .font(.headline)

                HStack {
                    Text("\(board.totalCards) tasks")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if board.totalCards > 0 {
                        ProgressBar(
                            progress: board.progressPercentage,
                            color: Color(hex: board.colorHex ?? "#4A90D9")
                        )
                        .frame(width: 60)
                    }
                }
            }

            Spacer()

            if board.totalCards > 0 {
                Text("\(Int(board.progressPercentage * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
