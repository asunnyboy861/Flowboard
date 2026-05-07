import CoreData
import Foundation

@objc(Board)
public class Board: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board")
    }

    @NSManaged public var colorHex: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var columns: NSSet?
}

extension Board {
    var columnsArray: [Column] {
        let set = columns as? Set<Column> ?? []
        return set.sorted { $0.sortOrder < $1.sortOrder }
    }

    var totalCards: Int {
        columnsArray.reduce(0) { $0 + (($1.cards as? Set<Card>)?.count ?? 0) }
    }

    var completedCards: Int {
        columnsArray.reduce(0) { result, column in
            let completed = (column.cards as? Set<Card>)?.filter { $0.isCompleted }.count ?? 0
            return result + completed
        }
    }

    var progressPercentage: Double {
        guard totalCards > 0 else { return 0 }
        return Double(completedCards) / Double(totalCards)
    }
}
