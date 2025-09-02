import UIKit

final class CityView: UIView {
    
    // MARK: - GUI Variable
    let cityButton = UIButton()
    let cityLabel  = UILabel()
    let cityIcon   = UIImageView()
    
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
        addSubview(cityButton)
        cityButton.addSubview(cityLabel)
        cityButton.addSubview(cityIcon)
    }
    
    private func makeConstraints() {
        cityButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        cityIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(cityLabel.snp.trailing).offset(4)
        }
    }
    
    private func setupView() {
        cityLabel.text = "Москва"
        cityLabel.textColor = .black
        cityLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cityIcon.image = UIImage(named: "chevronDown")
    }
}
