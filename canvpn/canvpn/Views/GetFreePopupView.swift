//
//  EmailPopupView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 6.09.2023.
//

import UIKit
import SnapKit
import Lottie

protocol GetFreePopupViewDelegate: AnyObject {
    func getButtonTapped(view: GetFreePopupView, email: String)
    func closeButtonTapped(view: GetFreePopupView)
}

class GetFreePopupView: UIView {
    
    public lazy var mainAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "congratsAnimation")
        animation.loopMode = .playOnce
        return animation
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = "Congratulations!"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "You won a chance for a one-month premium membership invitation with your account over an exclusive promo code. \nJust provide your email, and you can start experiencing the perks of premium access."
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.tintColor = .Custom.green
        textField.textColor = UIColor.gray
      //  textField.layer.borderWidth = 0.2
        textField.layer.cornerRadius = 6.0
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.applySketchShadow()
        
        let placeholder = "Enter your email"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Code".localize(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.Custom.green
        button.addTarget(self, action: #selector(getButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 21
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "bordered-close-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Public Variables
    public weak var delegate: GetFreePopupViewDelegate?
    
    // MARK: Life-Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        mainAnimation.play()
        
        self.snp.makeConstraints { make in
            make.width.equalTo(300)
        }
        
        self.addSubview(mainAnimation)
        mainAnimation.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainAnimation.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        self.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.height.equalTo(32)
            make.leading.trailing.equalToSuperview().inset(42)
        }
        
        self.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(24)
        }

        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
    }
    
    
    // MARK: Actions
    @objc private func getButtonTapped(_ sender: UIButton) {
        guard let emailText = emailTextField.text, !emailText.isEmpty else { return }
        delegate?.getButtonTapped(view: self, email: emailText)
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeButtonTapped(view: self)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
}

// MARK: Public Functions
extension GetFreePopupView {
    
    public func set(leaveButtonText: String) {
       // leaveGameButton.setTitle(leaveButtonText, for: .normal)
    }
    
}
