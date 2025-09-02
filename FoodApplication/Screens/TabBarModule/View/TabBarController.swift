import UIKit

protocol TabBarProtocol: AnyObject {
    func setAllControllers(controllers: [UIViewController])
}

final class TabBarController: UITabBarController, TabBarProtocol {
    
    // MARK: - Variable
    private let presenter: TabBarPresenterProtocol
    
    // MARK: - Init
    init(presenter: TabBarPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installCreatTabBar()
        setupTabBarAppearance()
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = appearance }
        tabBar.tintColor = .main
        tabBar.unselectedItemTintColor = .gray
        tabBar.isTranslucent = false
    }
    
    private func installCreatTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    func setAllControllers(controllers: [UIViewController]) {
        
        let meta: [(title: String, iconName: String)] = [
            ("Меню",     "menuIcon"),
            ("Контакты", "contactIcon"),
            ("Профиль",  "profileIcon"),
            ("Корзина",  "backetIcon"),
        ]
        
        viewControllers = zip(controllers, meta).map { viewController, m in
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem.title = m.title
            navigationController.tabBarItem.image = UIImage(named: m.iconName)
            return navigationController
        }
    }
}
