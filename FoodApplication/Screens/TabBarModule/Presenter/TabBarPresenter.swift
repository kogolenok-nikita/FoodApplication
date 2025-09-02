import UIKit

protocol TabBarPresenterProtocol: AnyObject {
    func attachView(_ view: TabBarProtocol)
    func viewDidLoad()
}

final class TabBarPresenter: TabBarPresenterProtocol {
    private weak var view: TabBarProtocol?
    private let router: RouterProtocol
    private let builder: BuilderProtocol
    
    init(router: RouterProtocol, builder: BuilderProtocol) {
        self.router = router
        self.builder = builder
    }
    
    func attachView(_ view: TabBarProtocol) { 
        self.view = view
    }
    
    func viewDidLoad() {
        let menu    = builder.createMenuModule(router: router)
        let contact = builder.createContactModule(router: router)
        let profile = builder.createProfileModule(router: router)
        let basket  = builder.createBacketModule(router: router)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let view = self.view else { return }
            view.setAllControllers(controllers: [menu, contact, profile, basket])
        }
    }
}
