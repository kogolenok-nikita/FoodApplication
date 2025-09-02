import UIKit

protocol BasketPresenterProtocol: AnyObject {
    func attachView(_ view: BasketViewProtocol)
    func viewDidLoad()
    func numberOfRows() -> Int
    func item(at index: Int) -> BasketModel
    func updateQuantity(at index: Int, to quantity: Int)
    func total() -> Int
    func removeItem(at index: Int)
}

final class BasketPresenter: BasketPresenterProtocol {
    private weak var view: BasketViewProtocol?
    private let router: RouterProtocol
    private var basketItems: [BasketModel] = []
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: any BasketViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.reload()
        view?.setTotal(minorUnits: total())
    }
    
    func numberOfRows() -> Int {
        return basketItems.count
    }
    
    func item(at index: Int) -> BasketModel {
        return basketItems[index]
    }
    
    func updateQuantity(at index: Int, to quantity: Int) {
        guard basketItems.indices.contains(index) else { return }
        var item = basketItems[index]
        let newQTY = max(1, quantity)
        item.quantity = newQTY
        basketItems[index] = item
        view?.reload()
        view?.setTotal(minorUnits: total())
    }
    
    func total() -> Int {
        return basketItems.reduce(0) { $0 + $1.unitPrice * $1.quantity }
    }
    
    func setItems(_ items: [BasketModel]) {
        self.basketItems = items
        view?.reload()
        view?.setTotal(minorUnits: total())
    }
    
    func removeItem(at index: Int) {
        guard basketItems.indices.contains(index) else { return }
        basketItems.remove(at: index)
        view?.reload()
        view?.setTotal(minorUnits: total())
    }
}
