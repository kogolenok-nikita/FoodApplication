import UIKit
import SnapKit

protocol MenuViewProtocol: AnyObject {
    func reload()
    func setCity(_ city: String)
    func setLoading(_ isLoading: Bool)
    func showError(_ message: String)
    func showOfflineMode()
}

final class MenuViewController: UIViewController {
    
    // MARK: - Variables
    private let presenter: MenuPresenterProtocol
    
    private var bannerHeightConstraint: Constraint?
    private var typeTopToBannerConstraint: Constraint?
    private var typeTopToCityConstraint: Constraint?
    private var isBannerCollapsed = false
    
    // MARK: - GUI Variables
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let navigationView    = CustomNavigationView()
    private let cityView          = CityView()
    private let bannerScrollView  = UIScrollView()
    private let bannerStackView   = UIStackView()
    private let bannerViewOne     = BannerView()
    private let bannerViewTwo     = BannerView()
    private let typeScrollView    = UIScrollView()
    private let typeStackView     = UIStackView()
    private let typeOneButton     = ButtonView()
    private let typeTwoButton     = ButtonView()
    private let typeThreeButton   = ButtonView()
    private let typeFourButton    = ButtonView()
    private let typeFiveButton    = ButtonView()
    private let typeSixButton     = ButtonView()
    private let tableView         = UITableView()
    private lazy var allTypeButton: [ButtonView] = [typeOneButton, typeTwoButton, typeThreeButton, typeFourButton, typeFiveButton, typeSixButton]
    
    // MARK: - Init
    init(presenter: MenuPresenterProtocol) {
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
        showSuccessBanner()
        presenter.viewDidLoad()
        CoreDataManager.shared.logCoreDataDBPath()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(navigationView)
        bannerStackView.addArrangedSubview(bannerViewOne)
        bannerStackView.addArrangedSubview(bannerViewTwo)
        bannerScrollView.addSubview(bannerStackView)
        typeStackView.addArrangedSubview(typeOneButton)
        typeStackView.addArrangedSubview(typeTwoButton)
        typeStackView.addArrangedSubview(typeThreeButton)
        typeStackView.addArrangedSubview(typeFourButton)
        typeStackView.addArrangedSubview(typeFiveButton)
        typeStackView.addArrangedSubview(typeSixButton)
        typeScrollView.addSubview(typeStackView)
        view.addSubview(activityIndicator)
        view.addSubview(cityView)
        view.addSubview(bannerScrollView)
        view.addSubview(typeScrollView)
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(50)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(52)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        cityView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(83)
            $0.height.equalTo(20)
        }
        
        bannerScrollView.snp.makeConstraints {
            $0.top.equalTo(cityView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            bannerHeightConstraint = $0.height.equalTo(112).constraint
        }
        
        bannerStackView.snp.makeConstraints {
            $0.edges.equalTo(bannerScrollView.contentLayoutGuide)
            $0.height.equalTo(bannerScrollView.frameLayoutGuide)
        }
        
        [bannerViewOne, bannerViewTwo].forEach { banner in
            banner.snp.makeConstraints {
                $0.width.equalTo(300)
                $0.height.equalTo(112)
            }
        }
        
        typeScrollView.snp.makeConstraints {
            $0.top.equalTo(bannerScrollView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        typeScrollView.snp.makeConstraints {
            typeTopToBannerConstraint = $0.top.equalTo(bannerScrollView.snp.bottom).offset(24).constraint
            typeTopToCityConstraint?.deactivate()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        typeStackView.snp.makeConstraints {
            $0.edges.equalTo(typeScrollView.contentLayoutGuide)
            $0.height.equalTo(typeScrollView.contentLayoutGuide)
        }
        
        [typeOneButton, typeTwoButton, typeThreeButton, typeFourButton, typeFiveButton, typeSixButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.equalTo(88)
                $0.height.equalTo(32)
            }
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(typeScrollView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .main
        cityView.cityButton.addTarget(self, action: #selector(cityButtonAction), for: .touchUpInside)
        cityView.isHidden = true
        bannerScrollView.layer.cornerRadius = 20
        bannerScrollView.showsHorizontalScrollIndicator = false
        bannerStackView.axis = .horizontal
        bannerStackView.spacing = 5
        bannerViewOne.iconName = UIImage(named: "banner1")
        bannerViewOne.layer.cornerRadius = 20
        bannerViewTwo.iconName = UIImage(named: "banner2")
        bannerViewTwo.layer.cornerRadius = 20
        bannerViewOne.buttom.addTarget(self, action: #selector(bannerAction), for: .touchUpInside)
        bannerViewTwo.buttom.addTarget(self, action: #selector(bannerAction), for: .touchUpInside)
        typeScrollView.showsHorizontalScrollIndicator = false
        typeScrollView.layer.cornerRadius = 15
        typeStackView.axis = .horizontal
        typeStackView.spacing = 5
        typeOneButton.titleButton = "Пицца"
        typeTwoButton.titleButton = "Салат"
        typeThreeButton.titleButton = "Десерты"
        typeFourButton.titleButton = "Фрукты"
        typeFiveButton.titleButton = "Паста"
        typeSixButton.titleButton = "Бургер"
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MenuViewCell.self, forCellReuseIdentifier: MenuViewCell.identifier)
        tableView.layer.cornerRadius = 20
        
        allTypeButton.enumerated().forEach { index, view in
            view.button.tag = index
            view.button.addTarget(self, action: #selector(buttonViewAction(_:)), for: .touchUpInside)
        }
    }
    
    private func showSuccessBanner() {
        navigationView.backgroundColor = .white
        navigationView.navTitle.text = "Вход выполнен успешно"
        navigationView.navTitle.textColor = .gn
        navigationView.navImage.image = UIImage(named: "checkCircle")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.navigationView.isHidden = true
            self?.cityView.isHidden = false
        }
    }
    
    private func resetAllTypeButtonsAppearance() {
        allTypeButton.forEach { v in
            v.layer.cornerRadius = 15
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.main.cgColor
            v.layer.opacity = 0.4
            v.backgroundColor = .white
            v.button.setTitleColor(.main, for: .normal)
        }
    }
    
    private func collapseBanner(_ collapse: Bool) {
        isBannerCollapsed = collapse
        
        if collapse {
            bannerHeightConstraint?.update(offset: 0)
            typeTopToBannerConstraint?.deactivate()
            typeTopToCityConstraint?.activate()
        } else {
            bannerHeightConstraint?.update(offset: 112)
            typeTopToCityConstraint?.deactivate()
            typeTopToBannerConstraint?.activate()
        }
        
        UIView.animate(withDuration: 0.25) {
            self.bannerScrollView.alpha = collapse ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func showTopBanner(text: String) {
        let banner = UILabel()
        banner.backgroundColor = .secondarySystemBackground
        banner.textColor = .label
        banner.textAlignment = .center
        banner.font = .systemFont(ofSize: 13, weight: .medium)
        banner.text = text
        banner.textColor = .main
        banner.layer.cornerRadius = 10
        view.addSubview(banner)
        banner.alpha = 0
        
        banner.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(32)
        }
    
        UIView.animate(withDuration: 0.2, animations: { banner.alpha = 1 }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.2, animations: { banner.alpha = 0 }) { _ in
                    banner.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func buttonViewAction(_ sender: UIButton) {
        resetAllTypeButtonsAppearance()
        
        let index = sender.tag
        guard allTypeButton.indices.contains(index) else { return }
        let selected = allTypeButton[index]
        
        selected.backgroundColor = .main
        selected.layer.opacity = 0.2
        selected.layer.borderWidth = 0
        selected.button.setTitleColor(.white, for: .normal)
        selected.button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        
        if index == 0 {
            presenter.didTapCategory(.pizza)
        } else if index == 1 {
            presenter.didTapCategory(.salad)
        } else if index == 2 {
            presenter.didTapCategory(.cake)
        } else if index == 3 {
            presenter.didTapCategory(.fruit)
        } else if index == 4 {
            presenter.didTapCategory(.pasta)
        } else if index == 5 {
            presenter.didTapCategory(.burger)
        }
    }
    
    @objc func cityButtonAction() {
        presenter.didTapCity()
    }
    
    @objc private func bannerAction() {
        presenter.didTapBanner()
    }
}

// MARK: - MenuViewProtocol
extension MenuViewController: MenuViewProtocol {
    func reload() {
        tableView.reloadData()
    }
    
    func setCity(_ city: String) {
        cityView.cityLabel.text = city
    }
    
    func setLoading(_ isLoading: Bool) {
        //[bannerScrollView, typeScrollView, tableView].forEach { $0.isHidden = isLoading }
        [tableView].forEach { $0.isHidden = isLoading }
        tableView.isUserInteractionEnabled = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        presentAlert(message: message) { [weak self] in
            guard let self = self else { return }
            self.presenter.viewDidLoad()
        }
    }
    
    func showOfflineMode() {
        showTopBanner(text: "Нет интернета. Показаны сохранённые данные.")
        (tableView.refreshControl)?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuViewCell.identifier, for: indexPath) as? MenuViewCell else { return UITableViewCell() }
        cell.delegate = self
        let model = presenter.item(at: indexPath.row)
        cell.setMenuModel(model: model)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return presenter.didSelectedRow(at: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableView else { return }
        let threshold: CGFloat = 20
        if scrollView.contentOffset.y > threshold, !isBannerCollapsed {
            collapseBanner(true)
        } else if scrollView.contentOffset.y <= threshold, isBannerCollapsed {
            collapseBanner(false)
        }
    }
}

// MARK: - MenuViewCellDelegate
extension MenuViewController: MenuViewCellDelegate {
    func menuCellDidTapAdd(_ cell: MenuViewCell, model: MenuModel) {
        let payload = AddToBasketPayload(imageURL: model.imageURL, title: model.title, unitPrice: 34500, quantity: 1)
        NotificationCenter.default.post(name: .addToBasket, object: payload)
        tabBarController?.selectedIndex = 3
    }
}
