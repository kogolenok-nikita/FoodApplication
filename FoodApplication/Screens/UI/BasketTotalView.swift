import UIKit

final class BasketTotalView: UIView {
    
    // MARK: - GUI Variable
    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    
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
        addSubview(totalLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        totalLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupView() {
        titleLabel.text = "Итого"
        titleLabel.textColor = .main
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        totalLabel.font = .systemFont(ofSize: 17, weight: .bold)
        totalLabel.textColor = .main
        backgroundColor = .background
    }
    
    func setTotal(minorUtits: Int) {
        let rub = Double(minorUtits) / 100.0
        totalLabel.text = String(format: "%.2f", rub)
    }
}
