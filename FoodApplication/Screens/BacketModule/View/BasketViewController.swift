import UIKit

protocol BasketViewProtocol: AnyObject {
    func reload()
    func setTotal(minorUnits: Int)
    func showError(_ message: String)
}

final class BasketViewController: UIViewController {
    
    // MARK: - Variable
    private let presenter: BasketPresenterProtocol
    
    // MARK: - GUI Variable
    let tableView = UITableView(frame: .zero, style: .plain)
    let footer = BasketTotalView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
    
    // MARK: - Init
    init(presenter: BasketPresenterProtocol) {
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
        view.backgroundColor = .background
        navigationController?.setNavigationBarHidden(true, animated: true)
        addSubviews()
        makeConstraints()
        setupView()
        presenter.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onAddToBasket(_:)), name: .addToBasket, object: nil)
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasketViewCell.self, forCellReuseIdentifier: BasketViewCell.identifier)
        tableView.tableFooterView = footer
    }
    
    private func format(price: Int) -> String {
        String(format: "$.2f", Double(price)/100.0)
    }
    
    // MARK: - Action
    @objc private func onAddToBasket(_ note: Notification) {
        guard let payload = note.object as? AddToBasketPayload else { return }
        let newItem = BasketModel(imageURL: payload.imageURL, title: payload.title, unitPrice: payload.unitPrice, quantity: payload.quantity)
        
        if let index = (0..<presenter.numberOfRows()).first(where: { presenter.item(at: $0).title == newItem.title }) {
            let current = presenter.item(at: index)
            presenter.updateQuantity(at: index, to: current.quantity + newItem.quantity)
        } else {
            var items = (0..<presenter.numberOfRows()).map { presenter.item(at: $0) }
            items.append(newItem)
            if let p = presenter as? BasketPresenter { 
                p.setItems(items)
            }
        }
    }
}

// MARK: - BasketViewProtocol
extension BasketViewController: BasketViewProtocol {
    func reload() {
        tableView.reloadData()
    }
    
    func setTotal(minorUnits: Int) {
        footer.setTotal(minorUtits: minorUnits)
    }
    
    func showError(_ message: String) {
        presentAlert(message: message) { [weak self] in
            guard let self = self else { return }
            self.presenter.viewDidLoad()
        }
    }
}

// MARK: - UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketViewCell.identifier, for: indexPath) as? BasketViewCell else { return UITableViewCell() }
        cell.delegate = self
        let model = presenter.item(at: indexPath.row)
        cell.setItem(model, subtitle: "Цена за шт: \(format(price: model.unitPrice))")
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeItem(at: indexPath.row)
        }
    }
}

// MARK: - UITableViewDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
}

// MARK: - BasketViewCellDelegate
extension BasketViewController: BasketViewCellDelegate {
    func basketCell(_ cell: BasketViewCell, didChangeQuantity quantity: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter.updateQuantity(at: indexPath.row, to: quantity)
        }
    }
}
