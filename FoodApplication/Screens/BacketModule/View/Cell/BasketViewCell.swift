import UIKit

protocol BasketViewCellDelegate: AnyObject {
    func basketCell(_ cell: BasketViewCell, didChangeQuantity quantity: Int)
}

final class BasketViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let identifier = "BasketViewCell"
    weak var delegate: BasketViewCellDelegate?
    private var item: BasketModel?
    
    // MARK: - GUI Variable
    let containerView = UIView()
    let imageViewCell = UIImageView()
    let labelsView    = UIView()
    let titleLable    = UILabel()
    let descriptLabel = UILabel()
    //let priceView     = PriceView()
    private let qtyContainer = UIView()
    private let minusButton  = UIButton(type: .system)
    private let qtyLabel     = UILabel()
    private let plusButton   = UIButton(type: .system)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
        setupView()
        setupActions()
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
        //labelsView.addSubview(priceView)
        labelsView.addSubview(qtyContainer)
        qtyContainer.addSubview(minusButton)
        qtyContainer.addSubview(qtyLabel)
        qtyContainer.addSubview(plusButton)
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
        
//        priceView.snp.makeConstraints {
//            $0.trailing.equalTo(labelsView.snp.trailing)
//            $0.width.equalTo(120)
//            $0.height.equalTo(32)
//            $0.bottom.equalTo(labelsView.snp.bottom)
//        }
        
        qtyContainer.snp.makeConstraints {
            $0.leading.equalTo(labelsView.snp.leading)
            $0.bottom.equalTo(labelsView.snp.bottom)
//            $0.centerY.equalTo(priceView.snp.centerY)
            $0.height.equalTo(32)
        }
        
        minusButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        qtyLabel.snp.makeConstraints {
            $0.leading.equalTo(minusButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints {
            $0.leading.equalTo(qtyLabel.snp.trailing).offset(8)
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
    }
    
    private func setupView() {
        imageViewCell.contentMode = .scaleAspectFit
        titleLable.textColor = .black
        titleLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptLabel.textColor = .icon
        descriptLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptLabel.numberOfLines = 0
        qtyContainer.layer.cornerRadius = 8
        qtyContainer.backgroundColor = .secondarySystemBackground
        minusButton.setTitle("−", for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        qtyLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        qtyLabel.textColor = .label
        qtyLabel.text = "1"
    }
    
    // MARK: - Actions
    private func setupActions() {
        minusButton.addTarget(self, action: #selector(onMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(onPlus), for: .touchUpInside)
    }
    
    @objc private func onMinus() {
        guard var item = item else { return }
        if item.quantity > 1 {
            item.quantity -= 1
            applyQuantity(item.quantity, unitPrice: item.unitPrice)
            self.item = item
            delegate?.basketCell(self, didChangeQuantity: item.quantity)
        }
    }
    
    @objc private func onPlus() {
        guard var item = item else { return }
        item.quantity += 1
        applyQuantity(item.quantity, unitPrice: item.unitPrice)
        self.item = item
        delegate?.basketCell(self, didChangeQuantity: item.quantity)
    }
    
    private func applyQuantity(_ qty: Int, unitPrice: Int) {
        qtyLabel.text = "\(qty)"
        let total = unitPrice * qty
        setPrice(total)
    }
    
    private func setPrice(_ priceInMinor: Int) {
        let rub = Double(priceInMinor) / 100.0
        let _ = String(format: "$.2f", rub)
//        priceView.setText(text)
    }
    
    func setItem(_ item: BasketModel, subtitle: String? = nil) {
        self.item = item
        imageViewCell.kf.setImage(with: URL(string: item.imageURL))
        titleLable.text = item.title
        descriptLabel.text = subtitle
        applyQuantity(item.quantity, unitPrice: item.unitPrice)
    }
}
