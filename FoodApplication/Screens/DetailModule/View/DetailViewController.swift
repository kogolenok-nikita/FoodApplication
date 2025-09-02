import UIKit

protocol DetailViewProtocol: AnyObject {
    func display(title: String, description: String, imageURL: String)
}

final class DetailViewController: UIViewController {
    
    // MARK: - Variable
    private let presenter: DetailPresenterProtocol
    
    // MARK: - GUI Variables
    private let mainImageView = UIImageView()
    private let labelsView    = LabelsView()
    private let priceView     = PriceView()
    private let basketButton  = UIButton()
    
    // MARK: - Init
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.attachView(self)
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
        setupNavBar()
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(mainImageView)
        view.addSubview(labelsView)
//        view.addSubview(priceView)
//        view.addSubview(basketButton)
    }
    
    private func makeConstraints() {
        mainImageView.snp.makeConstraints { 
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(132)
        }
        
        labelsView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
//        priceView.snp.makeConstraints {
//            $0.top.equalTo(labelsView.snp.bottom).offset(10)
//            $0.leading.equalTo(view.snp.leading).offset(16)
//            $0.trailing.equalTo(view.snp.trailing).offset(-16)
//            $0.height.equalTo(32)
//        }
        
//        basketButton.snp.makeConstraints {
//            $0.top.equalTo(priceView.snp.bottom).offset(10)
//            $0.leading.equalTo(view.snp.leading).offset(16)
//            $0.trailing.equalTo(view.snp.trailing).offset(-16)
//            $0.height.equalTo(48)
//        }
    }
    
    private func setupView() {
        mainImageView.contentMode = .scaleAspectFit
        labelsView.layer.borderColor = UIColor.icon.cgColor
//        basketButton.backgroundColor = .main
//        basketButton.layer.cornerRadius = 20
//        basketButton.setTitle("В корзину", for: .normal)
//        basketButton.setTitleColor(.white, for: .normal)
//        basketButton.addTarget(self, action: #selector(basketButtonAction), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backTapped))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.main
    }
    
    // MARK: - Action
    @objc private func backTapped() {
        presenter.didTabBack()
    }
    
    @objc private func basketButtonAction() {
//        presenter.didTapAddBasket()
    }
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func display(title: String, description: String, imageURL: String) {
        labelsView.configure(title: title, description: description)
        if let url = URL(string: imageURL) {
            mainImageView.kf.setImage(with: url, placeholder: nil)
        } else {
            mainImageView.image = nil
        }
    }
}
