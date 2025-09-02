import UIKit

protocol BuilderProtocol {
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createTabBarModule(router: RouterProtocol) -> UIViewController
    func createMenuModule(router: RouterProtocol) -> UIViewController
    func createContactModule(router: RouterProtocol) -> UIViewController
    func createProfileModule(router: RouterProtocol) -> UIViewController
    func createBacketModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol, model: MenuModel) -> UIViewController
    func createCityModule(router: RouterProtocol, onSelect: @escaping (String) -> Void) -> UIViewController
    func createBannerModule(router: RouterProtocol) -> UIViewController
}

final class Builder: BuilderProtocol {
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let presenter = LoginPresenter(router: router)
        let view = LoginViewController(presenter: presenter)
        return view
    }
    
    func createTabBarModule(router: RouterProtocol) -> UIViewController {
        let presenter = TabBarPresenter(router: router, builder: self)
        let tabBar = TabBarController(presenter: presenter)
        return tabBar
    }
    
    func createMenuModule(router: RouterProtocol) -> UIViewController {
        guard let baseURL = URL(string: "https://www.themealdb.com") else {
            assertionFailure("Invalid base URL")
            return UIViewController()
        }
        
        let network = NetworkService(baseURL: baseURL)
        let presenter = MenuPresenter(router: router, network: network)
        let view = MenuViewController(presenter: presenter)
        return view
    }
    
    func createContactModule(router: RouterProtocol) -> UIViewController {
        let presenter = ContactPresenter(router: router)
        let view = ContactViewController(presenter: presenter)
        return view
    }
    
    func createProfileModule(router: RouterProtocol) -> UIViewController {
        let presenter = ProfilePresenter(router: router)
        let view = ProfileViewController(presenter: presenter)
        return view
    }
    
    func createBacketModule(router: RouterProtocol) -> UIViewController {
        let presenter = BasketPresenter(router: router)
        let view = BasketViewController(presenter: presenter)
        return view
    }
    
    func createDetailModule(router: RouterProtocol, model: MenuModel) -> UIViewController {
        let presenter = DetailPresenter(router: router, model: model)
        let view = DetailViewController(presenter: presenter)
        return view
    }
    
    func createCityModule(router: RouterProtocol, onSelect: @escaping (String) -> Void) -> UIViewController {
        let presenter = CityPresenter(router: router, onSelect: onSelect)
        let view = CityViewController(presenter: presenter)
        return view
    }
    
    func createBannerModule(router: RouterProtocol) -> UIViewController {
        let presenter = BannerPresenter(router: router)
        let view = BannerViewController(presenter: presenter)
        return view
    }
}
