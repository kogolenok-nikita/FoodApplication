import UIKit
import CoreData

enum MenuCategory {
    case pizza
    case salad
    case cake
    case fruit
    case pasta
    case burger
}

protocol MenuPresenterProtocol: AnyObject {
    func attachView(_ view: MenuViewProtocol)
    func viewDidLoad()
    func numberOfRows() -> Int
    func item(at index: Int) -> MenuModel
    func didSelectedRow(at index: Int)
    func didTapCity()
    func didTapBanner()
    func didTapCategory(_ category: MenuCategory)
}

final class MenuPresenter: MenuPresenterProtocol {
    private weak var view: MenuViewProtocol?
    private let router: RouterProtocol
    private let network: NetworkServiceProtocol
    private var menuItems: [MenuModel] = []
    
    init(router: RouterProtocol, network: NetworkServiceProtocol) {
        self.router = router
        self.network = network
    }
    
    func attachView(_ view: MenuViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchMeals()
    }
    
    func numberOfRows() -> Int {
        return menuItems.count
    }
    
    func item(at index: Int) -> MenuModel {
        return menuItems[index]
    }
    
    func didSelectedRow(at index: Int) {
        let model = menuItems[index]
        router.showMenuDetail(with: model)
    }
    
    func didTapCity() {
        router.showCityPicker { [weak self] city in
            guard let self = self else { return }
            self.view?.setCity(city)
        }
    }
    
    func didTapBanner() {
        router.showBanner()
    }
    
    func didTapCategory(_ category: MenuCategory) {
        if !NetworkMonitor.shared.isConnected {
            loadOfflineDataIfNeeded()
            view?.showOfflineMode()
            return
        }
        
        view?.setLoading(true)
        let query: String
        switch category {
        case .pizza: query = "pizza"
        case .salad: query = "salad"
        case .cake:  query = "cake"
        case .fruit: query = "fruit"
        case .pasta: query = "pasta"
        case .burger: query = "burger"
        }
        let ep = MenuAPI.search(query)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            self.network.request(ep) { [weak self] (result: Result<SearchMealsResponce, NetworkError>) in
                guard let self else { return }
                switch result {
                case .success(let resp):
                    let meals = resp.meals
                    self.menuItems = meals.map {
                        MenuModel(
                            imageURL: $0.strMealThumb,
                            title: $0.strMeal,
                            description: "id: \($0.idMeal)"
                        )
                    }
                    self.view?.reload()
                    self.view?.setLoading(false)
                    self.saveOfflineData()
                case .failure(let err):
                    self.view?.showError(err.userMessage)
                    self.view?.setLoading(false)
                }
            }
        }
    }
    
    private func loadOfflineDataIfNeeded() {
        let request: NSFetchRequest<MenuEntity> = MenuEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 20
        
        if let entities = try? CoreDataManager.shared.context.fetch(request) {
            self.menuItems = entities.map { MenuModel.fromEntity($0) }
            self.view?.reload()
        }
    }
    
    private func saveOfflineData() {
        let request: NSFetchRequest<NSFetchRequestResult> = MenuEntity.fetchRequest()
        let deleteReuest = NSBatchDeleteRequest(fetchRequest: request)
        try? CoreDataManager.shared.context.execute(deleteReuest)
        
        for meal in menuItems {
            _ = meal.toEntity(in: CoreDataManager.shared.context)
        }
        CoreDataManager.shared.save()
    }
    
    private func fetchMeals() {
        if !NetworkMonitor.shared.isConnected {
            loadOfflineDataIfNeeded()
            view?.showOfflineMode()
            return
        }
        
        view?.setLoading(true)
        let ep = MenuAPI.italian()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            self.network.request(ep) { [weak self] (result: Result<FilterMealsResponse, NetworkError>) in
                guard let self else { return }
                switch result {
                case .success(let resp):
                    self.menuItems = resp.meals.map {
                        MenuModel(
                            imageURL: $0.strMealThumb,
                            title: $0.strMeal,
                            description: "Italian dish id: \($0.idMeal)"
                        )
                    }
                    self.view?.reload()
                    self.view?.setLoading(false)
                    self.saveOfflineData()
                case .failure(let err):
                    self.view?.showError(err.userMessage)
                    self.view?.setLoading(false)
                }
            }
        }
    }
}
