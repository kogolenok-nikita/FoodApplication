import UIKit

final class BasketButtonView: UIView {
    
    // MARK: - GUI Variables
    let basketButton = UIButton()
    
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
    
    private func addSubviews() {
        addSubview(basketButton)
    }
    
    private func makeConstraints() {
        basketButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        backgroundColor = .white
        basketButton.setImage(UIImage(named: "backetIcon"), for: .normal)
        basketButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
}
