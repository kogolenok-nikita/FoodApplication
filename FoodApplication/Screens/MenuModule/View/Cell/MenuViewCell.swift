import UIKit

protocol MenuViewCellDelegate: AnyObject {
    func menuCellDidTapAdd(_ cell: MenuViewCell, model: MenuModel)
}

final class MenuViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let identifier = "MenuViewCell"
    weak var delegate: MenuViewCellDelegate?
    private var currentModel: MenuModel?
    
    // MARK: - GUI Variables
    let containerView = UIView()
    let imageViewCell = UIImageView()
    let labelsView    = UIView()
    let titleLable    = UILabel()
    let descriptLabel = UILabel()
    let priceView     = PriceView()
    let buttonBasket  = ButtonView()
    
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
        labelsView.addSubview(titleLable)
        labelsView.addSubview(descriptLabel)
        labelsView.addSubview(priceView)
        labelsView.addSubview(buttonBasket)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        imageViewCell.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.width.equalTo(132)
        }
        
        labelsView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(8)
            $0.leading.equalTo(imageViewCell.snp.trailing).offset(32)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-24)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-24)
        }
        
        titleLable.snp.makeConstraints {
            $0.top.equalTo(labelsView.snp.top)
            $0.leading.equalTo(labelsView.snp.leading)
            $0.height.equalTo(20)
        }
        
        descriptLabel.snp.makeConstraints {
            $0.top.equalTo(titleLable.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        priceView.snp.makeConstraints {
            $0.leading.equalTo(labelsView.snp.leading)
//            $0.trailing.equalTo(labelsView.snp.trailing)
            $0.width.equalTo(87)
            $0.height.equalTo(32)
            $0.bottom.equalTo(labelsView.snp.bottom)
        }
        
        buttonBasket.snp.makeConstraints {
//            $0.leading.equalTo(priceView.snp.trailing).offset(10)
            $0.trailing.equalTo(labelsView.snp.trailing)
            $0.width.equalTo(87)
            $0.height.equalTo(32)
            $0.bottom.equalTo(labelsView.snp.bottom)
        }
    }
    
    private func setupView() {
        imageViewCell.image = UIImage(named: "pizza1")
        imageViewCell.contentMode = .scaleAspectFit
        titleLable.text = "Ветчина и грибы"
        titleLable.textColor = .black
        titleLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptLabel.text = "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус"
        descriptLabel.textColor = .icon
        descriptLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptLabel.numberOfLines = 0
        buttonBasket.layer.cornerRadius = 6
        buttonBasket.layer.opacity = 0.8
        buttonBasket.titleImage = UIImage(named: "backetIcon")?.withRenderingMode(.alwaysTemplate)
        buttonBasket.tintColor = .main
        buttonBasket.button.addTarget(self, action: #selector(buttonBasketAction), for: .touchUpInside)
    }
    
    func setMenuModel(model: MenuModel) {
        currentModel = model
        imageViewCell.kf.setImage(with: URL(string: model.imageURL))
        titleLable.text     = model.title
        descriptLabel.text  = model.description
    }
    
    // MARK: - Action
    @objc private func buttonBasketAction() {
        print("buttonBasketAction")
        guard let model = currentModel else { return }
        delegate?.menuCellDidTapAdd(self, model: model)
    }
}
