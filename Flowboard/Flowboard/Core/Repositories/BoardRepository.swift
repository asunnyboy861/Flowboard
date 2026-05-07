import CoreData

final class BoardRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createBoard(name: String, colorHex: String = "#4A90D9", icon: String = "folder") throws -> Board {
        let board = Board(context: context)
        board.id = UUID()
        board.name = name
        board.colorHex = colorHex
        board.icon = icon
        board.createdAt = Date()
        board.updatedAt = Date()

        let todoColumn = Column(context: context)
        todoColumn.id = UUID()
        todoColumn.name = "To Do"
        todoColumn.sortOrder = 0
        todoColumn.board = board

        let inProgressColumn = Column(context: context)
        inProgressColumn.id = UUID()
        inProgressColumn.name = "In Progress"
        inProgressColumn.sortOrder = 1
        inProgressColumn.board = board

        let doneColumn = Column(context: context)
        doneColumn.id = UUID()
        doneColumn.name = "Done"
        doneColumn.sortOrder = 2
        doneColumn.board = board

        try context.save()
        return board
    }

    func deleteBoard(_ board: Board) throws {
        context.delete(board)
        try context.save()
    }

    func updateBoard(_ board: Board, name: String? = nil, colorHex: String? = nil, icon: String? = nil) throws {
        if let name { board.name = name }
        if let colorHex { board.colorHex = colorHex }
        if let icon { board.icon = icon }
        board.updatedAt = Date()
        try context.save()
    }
}
