import UIKit

final class ProfileViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let identifier = "ProfileViewCell"
    
    // MARK: - GUI Variables
    let containerView = UIView()
    let imageViewCell = UIImageView()
    let labelsView = LabelsView()
    
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
    
    // MARK: - Methods
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageViewCell)
        containerView.addSubview(labelsView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageViewCell.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.width.height.equalTo(30)
        }
       
        labelsView.snp.makeConstraints {
            $0.leading.equalTo(imageViewCell.snp.trailing).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
            
        }
    }
    
    private func setupView() {
        imageViewCell.image = UIImage(named: "telegramIcon")
        imageViewCell.contentMode = .scaleAspectFit
        imageViewCell.layer.borderColor = UIColor.black.cgColor
        labelsView.layer.borderColor = UIColor.white.cgColor
        labelsView.titleLabel.text = "Title"
        labelsView.descriptLabel.text = "Description"
    }
    
    func setContactModel(model: ProfileModel) {
        imageViewCell.image           = UIImage(named: model.imageName)
        labelsView.titleLabel.text    = model.title
        labelsView.descriptLabel.text = model.description
    }
}
