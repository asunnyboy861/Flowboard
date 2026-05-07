import CoreData

final class ColumnRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addColumn(name: String, to board: Board) throws -> Column {
        let column = Column(context: context)
        column.id = UUID()
        column.name = name
        column.sortOrder = Int16(board.columnsArray.count)
        column.board = board
        try context.save()
        return column
    }

    func deleteColumn(_ column: Column) throws {
        context.delete(column)
        try context.save()
    }

    func renameColumn(_ column: Column, name: String) throws {
        column.name = name
        try context.save()
    }
}
