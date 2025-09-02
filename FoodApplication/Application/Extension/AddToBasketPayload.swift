import Foundation

extension Notification.Name {
    static let addToBasket = Notification.Name("addToBasket")
}

struct AddToBasketPayload {
    let imageURL: String
    let title: String
    let unitPrice: Int
    let quantity: Int
}
