import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController { get }
    var builder: BuilderProtocol { get }
    func initialViewController()
    func showMainTabBar()
    func popToRoot()
    func showMenuDetail(with model: MenuModel)
    func showCityPicker(onSelect: @escaping (String) -> Void)
    func showBanner()
    //func showBasket(with menu: MenuModel)
}

final class Router: RouterProtocol {
    let navigationController: UINavigationController
    var builder: BuilderProtocol
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func initialViewController() {
        navigationController.setNavigationBarHidden(true, animated: false)
        let login = builder.createLoginModule(router: self)
        navigationController.viewControllers = [login]
    }
    
    func showMainTabBar() {
        let tabBar = builder.createTabBarModule(router: self)
        navigationController.setViewControllers([tabBar], animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func showMenuDetail(with model: MenuModel) {
        let detailModule = builder.createDetailModule(router: self, model: model)
        navigationController.pushViewController(detailModule, animated: true)
    }
    
    func showCityPicker(onSelect: @escaping (String) -> Void) {
        let cityModule = builder.createCityModule(router: self, onSelect: onSelect)
        navigationController.pushViewController(cityModule, animated: true)
    }
    
    func showBanner() {
        let bannerModule = builder.createBannerModule(router: self)
        navigationController.pushViewController(bannerModule, animated: true)
    }
    
//    func showBasket(with menu: MenuModel) {
//        let basketItem = BasketModel(from: menu, unitPrice: 0, quantity: 1)
//        let presenter = BasketPresenter(router: self)
//        presenter.setItems([basketItem])
//        let basketView = BasketViewController(presenter: presenter)
//        navigationController.pushViewController(basketView, animated: true)
//    }
}
