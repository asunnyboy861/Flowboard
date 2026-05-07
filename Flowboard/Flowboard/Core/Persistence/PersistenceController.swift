import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    static var preview: PersistenceController {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        for i in 0..<3 {
            let board = Board(context: context)
            board.id = UUID()
            board.name = "Sample Board \(i + 1)"
            board.colorHex = ["#4A90D9", "#7B68EE", "#34C759"][i]
            board.icon = ["folder", "star", "heart"][i]
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

            for j in 0..<3 {
                let card = Card(context: context)
                card.id = UUID()
                card.title = "Task \(j + 1) in Board \(i + 1)"
                card.cardDescription = ""
                card.sortOrder = Int16(j)
                card.isCompleted = false
                card.priority = Int16(j % 4)
                card.createdAt = Date()
                card.updatedAt = Date()
                card.column = todoColumn
            }
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Flowboard")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to load persistent store description")
        }

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
