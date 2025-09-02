import UIKit

protocol ContactPresenterProtocol: AnyObject {
    func attachView(_ view: ContactViewProtocol)
    func viewDidLoad()
    func numberOfRows() -> Int
    func item(at index: Int) -> ContactModel
}

final class ContactPresenter: ContactPresenterProtocol {
    private weak var view: ContactViewProtocol?
    private let router: RouterProtocol
    private var contactItems: [ContactModel] = []
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: ContactViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.contactItems = [
                ContactModel(address: "Адрес1", timeWork: "Пн-Вс: 11:00-22:00"),
                ContactModel(address: "Адрес2", timeWork: "Пн-Вс: 11:00-23:00"),
                ContactModel(address: "Адрес3", timeWork: "Пн-Вс: 11:00-00:00"),
                ContactModel(address: "Адрес4", timeWork: "Пн-Вс: 11:00-21:00"),
                ContactModel(address: "Адрес5", timeWork: "Пн-Вс: 11:00-22:00"),
                ContactModel(address: "Адрес6", timeWork: "Пн-Вс: 11:00-23:00"),
                ContactModel(address: "Адрес7", timeWork: "Пн-Вс: 11:00-00:00"),
                ContactModel(address: "Адрес8", timeWork: "Пн-Вс: 11:00-01:00"),
                ContactModel(address: "Адрес9", timeWork: "Пн-Вс: 11:00-20:00")
            ]
            view?.reload()
            view?.setLoading(false)
        }
    }
    
    func numberOfRows() -> Int {
        return contactItems.count
    }
    
    func item(at index: Int) -> ContactModel {
        return contactItems[index]
    }
}
