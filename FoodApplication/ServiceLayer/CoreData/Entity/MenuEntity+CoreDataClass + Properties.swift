import Foundation
import CoreData

@objc(MenuEntity)
public class MenuEntity: NSManagedObject {}

extension MenuEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuEntity> {
        return NSFetchRequest<MenuEntity>(entityName: "MenuEntity")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var detail: String?
    @NSManaged public var timestamp: Date?

}

extension MenuEntity : Identifiable {}
