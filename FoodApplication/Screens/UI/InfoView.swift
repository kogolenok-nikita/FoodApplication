import UIKit

final class InfoView: UIView {
    
    // MARK: - GUI Variable
    private let iconEmail  = UIImageView()
    private let iconPhone  = UIImageView()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    
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
        addSubview(iconEmail)
        addSubview(iconPhone)
        addSubview(emailLabel)
        addSubview(phoneLabel)
    }
    
    private func makeConstraints() {
        iconEmail.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(5)
            $0.leading.equalTo(snp.leading).offset(5)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(5)
            $0.leading.equalTo(iconEmail.snp.trailing).offset(5)
        }
        
        iconPhone.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(5)
            $0.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        phoneLabel.snp.makeConstraints {
            $0.leading.equalTo(iconPhone.snp.trailing).offset(5)
            $0.bottom.equalTo(snp.bottom).offset(-8)
        }
    }
    
    private func setupView() {
        iconEmail.image = UIImage(systemName: "mail.fill")
        iconEmail.tintColor = .icon
        iconPhone.image = UIImage(systemName: "phone.fill")
        iconPhone.tintColor = .icon
        emailLabel.text = "infoPizza@pizza.com"
        emailLabel.textColor = .main
        phoneLabel.text = "6677"
        phoneLabel.textColor = .main
    }
}
