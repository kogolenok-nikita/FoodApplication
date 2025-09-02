import UIKit

protocol BannerViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
}

final class BannerViewController: UIViewController {
    
    // MARK: - Variable
    private let presenter: BannerPresenterProtocol
    private var loadingTimer: Timer?
    private let loadingDuration: TimeInterval = 5
    
    // MARK: - GUI Variable
    private let loadingProgressView = UIProgressView(progressViewStyle: .bar)
    private let imageView = UIImageView()
    private let closeButtom = UIButton()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        addSubviews()
        makeConstraints()
        setupView()
        presenter.viewDidLoad() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    init(presenter: BannerPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(loadingProgressView)
        view.addSubview(closeButtom)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingProgressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(imageView.snp.leading).offset(16)
            $0.trailing.equalTo(imageView.snp.trailing).offset(-16)
        }
        
        closeButtom.snp.makeConstraints {
            $0.top.equalTo(loadingProgressView.snp.bottom).offset(10)
            $0.trailing.equalTo(imageView.snp.trailing).offset(-16)
            $0.width.height.equalTo(44)
        }
    }
    
    private func setupView() {
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFill
        loadingProgressView.backgroundColor = .icon
        loadingProgressView.progress = 0
        loadingProgressView.progressTintColor = .main
        loadingProgressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        loadingProgressView.layer.cornerRadius = 2
        closeButtom.backgroundColor = .icon
        closeButtom.layer.cornerRadius = 22
        closeButtom.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButtom.tintColor = .main
        closeButtom.addTarget(self, action: #selector(closeButtomAction), for: .touchUpInside)
    }
    
    private func startLoadingProgress() {
        loadingProgressView.isHidden = false
        loadingProgressView.progress = 0

        loadingTimer?.invalidate()
        let startDate = Date()
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] t in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startDate)
            let progress = min(Float(elapsed / self.loadingDuration), 1.0)
            self.loadingProgressView.setProgress(progress, animated: true)
            if progress >= 1.0 {
                t.invalidate()
            }
        }
    }

    private func finishLoadingProgress() {
        loadingTimer?.invalidate()
        loadingProgressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.loadingProgressView.progress = 0
        }
    }
    
    // MARK: - Action
    @objc private func closeButtomAction() {
        presenter.didTapBack()
    }
}

// MARK: - BannerViewProtocol
extension BannerViewController: BannerViewProtocol {
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            startLoadingProgress()
        } else {
            finishLoadingProgress()
        }
    }
}
