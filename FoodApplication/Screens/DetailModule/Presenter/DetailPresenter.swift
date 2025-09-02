import UIKit

protocol DetailPresenterProtocol: AnyObject {
    func attachView(_ view: DetailViewProtocol)
    func viewDidLoad()
    func didTabBack()
//    func didTapAddBasket()
}

final class DetailPresenter: DetailPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private let router: RouterProtocol
    let model: MenuModel
    
    init(router: RouterProtocol, model: MenuModel) {
        self.router = router
        self.model = model
    }
    
    func attachView(_ view: any DetailViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.display(title: model.title, description: model.description, imageURL: model.imageURL)
    }
    
    func didTabBack() {
        router.popToRoot()
    }
    
//    func didTapAddBasket() {
//        router.showBasket(with: model)
//    }
}
