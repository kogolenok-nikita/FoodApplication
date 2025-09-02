import UIKit

protocol CityViewProtocol: AnyObject {
    func reload()
}

final class CityViewController: UIViewController {
    
    // MARK: - Variable
    private let presenter: CityPresenterProtocol
    
    // MARK: - GUI Variable
    let tableView = UITableView()
    
    // MARK: - Init
    init(presenter: CityPresenterProtocol) {
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
        addSubviews()
        makeConstraints()
        setupView()
        presenter.viewDidLoad()
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
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
    }
}

// MARK: - CityViewProtocol
extension CityViewController: CityViewProtocol {
    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as? CityCell else { return UITableViewCell() }
        cell.backgroundColor = .white
        cell.cityNameLabel.text = presenter.city(at: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return presenter.didSelectedRow(at: indexPath.row)
    }
}
