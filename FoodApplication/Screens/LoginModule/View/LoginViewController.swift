import UIKit

protocol LoginViewProtocol: AnyObject {
    func showErrorBanner(_ message: String)
    func hideErrorBanner()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Varaible
    private let presenter: LoginPresenterProtocol
    private var isPasswordHidden = true
    
    // MARK: - GUI Variables
    private let navigationView = CustomNavigationView()
    private let logoImage      = UIImageView()
    private let mainStackView  = UIStackView()
    private let emailView      = IconTextFieldView()
    private let passwordView   = IconTextFieldView()
    private let bottomView     = UIView()
    private let continueButton = UIButton()
    
    //MARK: - Init
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController!.setNavigationBarHidden(true, animated: false) 
        addSubviews()
        makeConstraints()
        setupView()
        setupKeyboardObservers()
        setupTapGesture()
        presenter.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(navigationView)
        view.addSubview(logoImage)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(emailView)
        mainStackView.addArrangedSubview(passwordView)
        view.addSubview(bottomView)
        bottomView.addSubview(continueButton)
        
    }
    
    private func makeConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(44)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(52)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(32)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(118)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(10)
            $0.leading.equalTo(bottomView.snp.leading).offset(16)
            $0.trailing.equalTo(bottomView.snp.trailing).offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    private func setupView() {
        logoImage.image = UIImage(named: "logo2")
        logoImage.contentMode = .scaleAspectFit
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.distribution = .fillEqually
        emailView.iconName = UIImage(named: "iconLogin")
        emailView.placeholderText = "Логин"
        emailView.textField.keyboardType = .emailAddress
        emailView.textField.autocapitalizationType = .none
        emailView.textField.autocorrectionType = .no
        emailView.textField.spellCheckingType = .no
        emailView.showTextBtn.isHidden = true
        emailView.textField.returnKeyType = .next
        emailView.textField.delegate = self
        emailView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordView.iconName = UIImage(named: "iconPassword")
        passwordView.placeholderText = "Пароль"
        passwordView.tintColor = .icon
        passwordView.iconCloseOpen.image = UIImage(named: "eyeClose")
        passwordView.showTextBtn.addTarget(self, action: #selector(showTextBtnAction), for: .touchUpInside)
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.autocorrectionType = .no
        passwordView.textField.spellCheckingType = .no
        passwordView.textField.returnKeyType = .done
        passwordView.textField.delegate = self
        passwordView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        bottomView.layer.cornerRadius = 20
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor.background.cgColor
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.backgroundColor = .white
        continueButton.backgroundColor = .main
        continueButton.layer.cornerRadius = 20
        continueButton.setTitle("Войти", for: .normal)
        continueButton.setTitle("Вход", for: .disabled)
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        
        updateContinueButtonState()
    }
    
    private func updateContinueButtonState() {
        let email = emailView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordView.textField.text ?? ""
        continueButton.isEnabled = !email.isEmpty && !password.isEmpty
        continueButton.alpha = continueButton.isEnabled ? 1.0 : 0.6
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    

    // MARK: - Action
    @objc private func continueButtonAction() {
        
        let email = emailView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordView.textField.text ?? ""
        
        presenter.didTapContinue(email: email, password: password)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        self.logoImage.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        self.mainStackView.snp.updateConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(32)
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        self.bottomView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
            $0.height.equalTo(88)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        self.logoImage.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121)
        }
        
        self.mainStackView.snp.updateConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(32)
        }
        
        self.bottomView.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(118)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        
    }
    
    @objc private func showTextBtnAction() {
        isPasswordHidden.toggle()
        
        if isPasswordHidden {
            passwordView.iconCloseOpen.image = UIImage(named: "eyeClose")
            passwordView.textField.isSecureTextEntry = true
        } else {
            passwordView.iconCloseOpen.image = UIImage(named: "eyeOpen")
            passwordView.textField.isSecureTextEntry = false
        }
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func showErrorBanner(_ message: String) {
        navigationView.navTitle.text = message
        navigationView.navImage.image = UIImage(named: "closeCircle")
        navigationView.isHidden = false
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.hideErrorBanner()
        }
    }
    
    func hideErrorBanner() {
        navigationView.isHidden = true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailView.textField {
            passwordView.textField.becomeFirstResponder()
        } else if textField === passwordView.textField {
            textField.resignFirstResponder()
            continueButtonAction()
        }
        return true
    }
}
