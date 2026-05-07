import CoreData

final class CardRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createCard(title: String, in column: Column, priority: Int16 = 0, dueDate: Date? = nil) throws -> Card {
        let card = Card(context: context)
        card.id = UUID()
        card.title = title
        card.sortOrder = Int16(column.cardsArray.count)
        card.isCompleted = false
        card.priority = priority
        card.dueDate = dueDate
        card.createdAt = Date()
        card.updatedAt = Date()
        card.column = column
        try context.save()
        return card
    }

    func updateCard(_ card: Card, title: String? = nil, cardDescription: String? = nil, dueDate: Date? = nil, priority: Int16? = nil, isCompleted: Bool? = nil, assignee: String? = nil) throws {
        if let title { card.title = title }
        if let cardDescription { card.cardDescription = cardDescription }
        if let dueDate { card.dueDate = dueDate }
        if let priority { card.priority = priority }
        if let isCompleted { card.isCompleted = isCompleted }
        if let assignee { card.assignee = assignee }
        card.updatedAt = Date()
        try context.save()
    }

    func moveCard(_ card: Card, to column: Column, at index: Int) throws {
        card.column = column
        card.sortOrder = Int16(index)
        card.updatedAt = Date()
        try context.save()
    }

    func deleteCard(_ card: Card) throws {
        context.delete(card)
        try context.save()
    }
}
