import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func attachView(_ view: ProfileViewProtocol)
    func viewDidLoad()
    func numberOfRows() -> Int
    func item(at index: Int) -> ProfileModel
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private weak var view: ProfileViewProtocol?
    private let router: RouterProtocol
    private var profileItems: [ProfileModel] = []
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: any ProfileViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileItems = [
            ProfileModel(imageName: "emailIcon", title: "Email", description: "kogolenoknikita@gmail.com"),
            ProfileModel(imageName: "telegramIcon", title: "Telegram", description: "@kogolenoknikita"),
            ProfileModel(imageName: "phoneIcon", title: "Phone", description: "+375(29)190-85-93"),
            ProfileModel(imageName: "linkedinIcon", title: "LinkedIn", description: "Nikita Kogolenok"),
            ProfileModel(imageName: "githubIcon", title: "GitHub", description: "nikkogolenok"),
        ]
        view?.reload()
    }
    
    func numberOfRows() -> Int {
        return profileItems.count
    }
    
    func item(at index: Int) -> ProfileModel {
        return profileItems[index]
    }
}
 
