import UIKit

final class ButtonView: UIView {
    
    // MARK: - Variables
    var titleButton: String? {
        didSet {
            button.setTitle(titleButton, for: .normal)
        }
    }
    
    var titleImage: UIImage? {
        didSet {
            button.setImage(titleImage, for: .normal)
        }
    }
    
    // MARK: - GUI Variables
    let button = UIButton()
    
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
        addSubview(button)
    }
    
    private func makeConstraints() {
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        layer.opacity = 0.4
        backgroundColor = .white
        button.setTitleColor(.main, for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
    }
}
