import UIKit

final class BannerView: UIView {
    
    // MARK: - Variable
    var iconName: UIImage? {
        didSet {
            imageView.image = iconName
        }
    }
    
    // MARK: - GUI Variable
    let imageView = UIImageView()
    let buttom    = UIButton()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func addSubviews() {
        addSubview(imageView)
        addSubview(buttom)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(112)
        }
        
        buttom.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = false
        layer.cornerRadius = 20
    }
}
