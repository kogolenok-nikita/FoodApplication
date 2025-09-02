import Foundation
import CoreData

struct MenuModel {
    let imageURL:   String
    let title:       String
    let description: String
}

struct FilterMealsResponse: Decodable {
    let meals: [FilterMeal]
}

struct SearchMealsResponce: Decodable {
    let meals: [FilterMeal]
}

struct FilterMeal: Decodable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

enum MenuAPI {
    static func italian() -> EndPoint {
        EndPoint(path: "/api/json/v1/1/filter.php", query: ["a": "Italian"])
    }
    
    static func search(_ q: String = "") -> EndPoint {
        EndPoint(path: "/api/json/v1/1/search.php", query: ["s": q])
    }
}

extension MenuModel {
    func toEntity(in context: NSManagedObjectContext) -> MenuEntity {
        let entity = MenuEntity(context: context)
        entity.imageURL = imageURL
        entity.title = title
        entity.detail = description
        entity.timestamp = Date()
        return entity
    }
    
    static func fromEntity(_ entity: MenuEntity) -> MenuModel {
        MenuModel(imageURL: entity.imageURL ?? "",
                  title: entity.title ?? "",
                  description: entity.detail ?? ""
        )
    }
}
