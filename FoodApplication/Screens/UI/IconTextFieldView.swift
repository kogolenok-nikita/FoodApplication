import UIKit

final class IconTextFieldView: UIView {
    
    // MARK: - Variables
    var iconName: UIImage? {
        didSet {
            iconImageView.image = iconName            
        }
    }
    
    var placeholderText: String? {
        didSet {
            textField.placeholder = placeholderText
        }
    }
    
    // MARK: - GUI Variables
    let stackView     = UIStackView()
    let iconImageView = UIImageView()
    let textField     = UITextField()
    let iconCloseOpen = UIImageView()
    let showTextBtn   = UIButton()
    
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
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(iconCloseOpen)
        addSubview(showTextBtn)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        iconCloseOpen.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        showTextBtn.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.trailing.equalTo(snp.trailing).offset(-10)
//            $0.centerX.equalTo(snp.centerX)
            $0.width.height.equalTo(24)
        }
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.layer.cornerRadius = 20
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray.cgColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .icon
        textField.textColor = .black
        iconCloseOpen.contentMode = .scaleAspectFit
        iconCloseOpen.tintColor = .icon
    }
}
