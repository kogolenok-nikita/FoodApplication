import UIKit

final class LabelsView: UIView {
    
    // MARK: - GUI Variable
    let titleLabel    = UILabel()
    let descriptLabel = UILabel()
    
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
        addSubview(titleLabel)
        addSubview(descriptLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(snp.bottom).offset(-2)
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptLabel.textColor = .icon
        descriptLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptLabel.numberOfLines = 0
    }
    
    func configure(title: String, description: String) {
        titleLabel.text    = title
        descriptLabel.text = description
    }
}
