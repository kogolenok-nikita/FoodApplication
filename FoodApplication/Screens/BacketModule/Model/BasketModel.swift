import Foundation

struct BasketModel: Codable, Equatable {
    let imageURL: String
    let title: String
    let unitPrice: Int
    var quantity: Int
    
    init(imageURL: String, title: String, unitPrice: Int, quantity: Int = 1) {
        self.imageURL = imageURL
        self.title = title
        self.unitPrice = unitPrice
        self.quantity = quantity
    }
    
    init(from menu: MenuModel, unitPrice: Int, quantity: Int = 1) {
        self.imageURL = menu.imageURL
        self.title = menu.title
        self.unitPrice = unitPrice
        self.quantity = quantity
    }
}
