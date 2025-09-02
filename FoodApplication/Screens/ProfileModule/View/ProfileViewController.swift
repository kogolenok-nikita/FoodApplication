import UIKit

protocol ProfileViewProtocol: AnyObject {
    func reload()
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Variables
    private let presenter: ProfilePresenterProtocol
    
    // MARK: - GUI Variables
    private let backgroundImageView = UIImageView()
    private let profileImageView    = UIImageView()
    private let titleLabel          = UILabel()
    private let tableView           = UITableView()
    
    // MARK: - Init
    init(presenter: ProfilePresenterProtocol) {
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
        view.addSubview(backgroundImageView)
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupView() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "IOS")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "iam")
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        titleLabel.text = "Nikita Kogolenok"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: ProfileViewCell.identifier)
    }
}

// MARK: -
extension ProfileViewController: ProfileViewProtocol {
    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as? ProfileViewCell else { return UITableViewCell() }
        let model = presenter.item(at: indexPath.row)
        cell.setContactModel(model: model)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
