import UIKit

final class CustomNavigationView: UIView {
    
    // MARK: - GUI Variables
    let navTitle = UILabel()
    let navImage = UIImageView()
    
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
    
    // MARK: - Method
    private func addSubviews() {
        addSubview(navTitle)
        addSubview(navImage)
    }
    
    private func makeConstraints() {
        navTitle.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
        }
        
        navImage.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.trailing.equalTo(snp.trailing).offset(-10)
        }
    }
    
    private func setupView() {
        navTitle.textColor = .main
        navTitle.numberOfLines = 0
        navTitle.textAlignment = .center
        layer.cornerRadius = 20
    }
}
