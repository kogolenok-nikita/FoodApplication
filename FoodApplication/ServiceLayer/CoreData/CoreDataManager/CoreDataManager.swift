import CoreData

final class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    private override init() {
        persistentContainer = NSPersistentContainer(name: "CoreData")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            } else {
                print("Database URL -", description.url?.absoluteString)
            }
        }
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
    public func logCoreDataDBPath() {
        if let url = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("DB url - \(url)")
        }
    }
}
