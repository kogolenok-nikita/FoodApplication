import UIKit

protocol ContactViewProtocol: AnyObject {
    func reload()
    func setLoading(_ isLoading: Bool)
}

final class ContactViewController: UIViewController {
    
    // MARK: - Variable
    private let presenter: ContactPresenterProtocol
    
    // MARK: - GUI Variable
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private let infoView  = InfoView()
    
    // MARK: - Init
    init(presenter: ContactPresenterProtocol) {
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
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        view.addSubview(infoView)
    }
    
    private func makeConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoView.snp.top)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(5)
            $0.height.equalTo(70)
        }
    }
    
    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .main
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }
}

// MARK: - ContactViewProtocol
extension ContactViewController: ContactViewProtocol {
    func reload() {
        tableView.reloadData()
    }
    
    func setLoading(_ isLoading: Bool) {
        [tableView].forEach { $0.isHidden = isLoading }
        tableView.isUserInteractionEnabled = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else { return UITableViewCell() }
        let model = presenter.item(at: indexPath.row)
        cell.setContactModel(model: model)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
