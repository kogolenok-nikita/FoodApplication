import UIKit

protocol BannerPresenterProtocol: AnyObject {
    func attachView(_ view: BannerViewProtocol)
    func viewDidLoad()
    func didTapBack()
}

final class BannerPresenter: BannerPresenterProtocol {
    private weak var view: BannerViewProtocol?
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: BannerViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setLoading(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            self.router.popToRoot()
            view?.setLoading(false)
        }
    }
    
    func didTapBack() {
        router.popToRoot()
    }
}
