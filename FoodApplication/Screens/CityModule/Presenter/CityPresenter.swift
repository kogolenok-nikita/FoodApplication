import UIKit

protocol CityPresenterProtocol: AnyObject {
    func attachView(_ view: CityViewProtocol)
    func viewDidLoad()
    func numberOfRows() -> Int
    func city(at index: Int) -> String
    func didSelectedRow(at index: Int)
}

final class CityPresenter: CityPresenterProtocol {
    private weak var view: CityViewProtocol?
    private let router: RouterProtocol
    private let onSelect: (String) -> Void
    private var cities: [String] = ["Брест", "Витебск", "Гомель", "Гродно", "Могилев", "Минск", "Москва", "Санкт-Петербург"]
    
    init(router: RouterProtocol, onSelect: @escaping (String) -> Void) {
        self.router = router
        self.onSelect = onSelect
    }
    
    func attachView(_ view: any CityViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
//        cityItems = [
//            CityModel(titleCity: "Брест"),
//            CityModel(titleCity: "Витебск"),
//            CityModel(titleCity: "Гомель"),
//            CityModel(titleCity: "Гродно"),
//            CityModel(titleCity: "Могилев"),
//            CityModel(titleCity: "Минск"),
//            CityModel(titleCity: "Москва"),
//            CityModel(titleCity: "Санкт-Петербург"),
//        ]
        view?.reload()
    }
    
    func numberOfRows() -> Int {
        return cities.count
    }
    
    func city(at index: Int) -> String {
        return cities[index]
    }
    
    func didSelectedRow(at index: Int) {
        onSelect(cities[index])
        router.popToRoot()
    }
}
