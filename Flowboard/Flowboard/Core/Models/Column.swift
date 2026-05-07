import CoreData
import Foundation

@objc(Column)
public class Column: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Column> {
        return NSFetchRequest<Column>(entityName: "Column")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var wipLimit: Int16
    @NSManaged public var board: Board?
    @NSManaged public var cards: NSSet?
}

extension Column {
    var cardsArray: [Card] {
        let set = cards as? Set<Card> ?? []
        return set.sorted { $0.sortOrder < $1.sortOrder }
    }
}
