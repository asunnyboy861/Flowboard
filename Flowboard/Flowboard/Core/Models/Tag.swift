import CoreData
import Foundation

@objc(Tag)
public class Tag: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var colorHex: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?
}

extension Tag {
    var cardsArray: [Card] {
        let set = cards as? Set<Card> ?? []
        return set.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
    }
}
