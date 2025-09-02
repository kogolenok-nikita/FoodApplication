import UIKit

final class PriceView: UIView {
    
    // MARK: - GUI Variable
    let fromLabel      = UILabel()
    let valueLabel     = UILabel()
    let typeValueLabel = UILabel()
    
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
        addSubview(fromLabel)
        addSubview(valueLabel)
        addSubview(typeValueLabel)
    }
    
    private func makeConstraints() {
        fromLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(snp.leading).offset(18)
        }
        
        valueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(fromLabel.snp.trailing).offset(2)
        }
        
        typeValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(valueLabel.snp.trailing).offset(2)
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        fromLabel.text = "от"
        fromLabel.textColor = .main
        fromLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        valueLabel.text = "345"
        valueLabel.textColor = .main
        valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        typeValueLabel.text = "р"
        typeValueLabel.textColor = .main
        typeValueLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    func setText(_ text: String) {
        
    }
}
