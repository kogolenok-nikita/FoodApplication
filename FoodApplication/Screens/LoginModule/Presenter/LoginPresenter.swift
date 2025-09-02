import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func attachView(_ view: LoginViewProtocol)
    func viewDidLoad()
    func didTapContinue(email: String, password: String)
}

final class LoginPresenter: LoginPresenterProtocol {
    private weak var view: LoginViewProtocol?
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: LoginViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func didTapContinue(email: String, password: String) {
        view?.hideErrorBanner()
        
        guard !email.isEmpty, !password.isEmpty else {
            view?.showErrorBanner("Заполните логин или пароль")
            return
        }
        
        guard isValidEmail(email) else {
            view?.showErrorBanner("Некорректный email")
            return
        }
        
        guard password == "Qwerty123" else {
            view?.showErrorBanner("Неверный логин или пароль")
            return
        }
        
        router.showMainTabBar()
    }
    
    private func isValidEmail(_ text: String) -> Bool {
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: text)
    }
}
