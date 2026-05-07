import CoreData
import Foundation

@objc(Card)
public class Card: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var assignee: String?
    @NSManaged public var cardDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var reminderDate: Date?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var column: Column?
    @NSManaged public var tags: NSSet?
}

extension Card {
    var priorityColor: String {
        switch priority {
        case 3: return "#FF3B30"
        case 2: return "#FF9500"
        case 1: return "#FFCC00"
        default: return "#8E8E93"
        }
    }

    var priorityName: String {
        switch priority {
        case 3: return "Urgent"
        case 2: return "High"
        case 1: return "Medium"
        default: return "Low"
        }
    }

    var isOverdue: Bool {
        guard let due = dueDate, !isCompleted else { return false }
        return due < Date()
    }

    var isDueToday: Bool {
        guard let due = dueDate else { return false }
        return Calendar.current.isDateInToday(due)
    }

    var tagsArray: [Tag] {
        let set = tags as? Set<Tag> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
}
