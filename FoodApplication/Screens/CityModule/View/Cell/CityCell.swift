import UIKit

final class CityCell: UITableViewCell {
    
    // MARK: - Variable
    static let identifier = "CityCell"
    
    // MARK: - GUI Variable
    let cityNameLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Meethods
    private func addSubviews() {
        contentView.addSubview(cityNameLabel)
    }
    
    private func makeConstraints() {
        cityNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(snp.leading).offset(15)
        }
    }
    
    private func setupView() {
        cityNameLabel.textColor = .black
    }
    
    func setupCityModel(model: CityModel) {
        cityNameLabel.text = model.titleCity
    }
}
