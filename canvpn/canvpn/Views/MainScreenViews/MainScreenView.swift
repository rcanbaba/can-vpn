//
//  MainScreenView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.12.2022.
//

import UIKit
import SnapKit
import Lottie

protocol MainScreenViewDelegate: AnyObject {
    func changeStateTapped()
    func locationButtonTapped()
    func goProButtonTapped()
    func getFreeTapped()
}

class MainScreenView: UIView {
    
    public weak var delegate: MainScreenViewDelegate?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var connectionStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        return label
    }()
    
    private lazy var centerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(connectButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 85
        button.setImage(UIImage(named: "power-orange-button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var privacyTextView: UITextView = {
        var textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.linkTextAttributes = [.foregroundColor: UIColor.Text.dark, .underlineStyle: true]
        return textView
    }()
    
    private lazy var locationButton: LocationButton = {
        let button = LocationButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationButtonTapped(_:))))
        return button
    }()
    
    public lazy var goProButton: GoProButton = {
        let button = GoProButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goProButtonTapped(_:))))
        return button
    }()
    
    public lazy var getFreeAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "pennantAnimation")
        animation.loopMode = .playOnce
        animation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getFreeTapped(_:))))
        animation.isHidden = true
        return animation
    }()
    
    public lazy var getFreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.textColor = UIColor.Custom.orange
        label.textAlignment = .center
        label.isHidden = true
        label.text = SettingsManager.shared.settings?.interface.showEmailBanner.text
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(backgroundImageView)
        
        let topOffset = UIScreen.main.bounds.height / 11.7
        
        addSubview(topLogoImageView)
        topLogoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.7)
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(12)
        }
        
        addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        setPrivacyText()
        
        addSubview(goProButton)
        goProButton.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(privacyTextView.snp.top).inset(-35)
        }
        
        addSubview(locationButton)
        locationButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(goProButton.snp.top).inset(-35)
        }

        addSubview(connectionStateLabel)
        connectionStateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(locationButton.snp.top).inset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
        
        addSubview(centerButton)
        centerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.9)
            make.height.equalTo(centerButton.snp.width)
            make.bottom.equalTo(connectionStateLabel.snp.top).inset(-10)
        }
        
        addSubview(getFreeAnimation)
        getFreeAnimation.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(6)
            make.top.equalTo(topLogoImageView.snp.top).offset(-10)
            make.size.equalTo(84)
        }
        
        getFreeAnimation.addSubview(getFreeLabel)
        getFreeLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(20)
        }

    }
    
    private func setPrivacyText () {
        let baseString = "pp_tos_key".localize() + "\n" + "Need help? Visit F.A.Q or reach out via Contact Us"
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        let tosDefaultUrl = SettingsManager.shared.settings?.links.termsURL ?? Constants.appTermsOfServicePageURLString
        var attributedString = NSMutableAttributedString(string: baseString)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: baseString,
            replaceTextAttributes: [
                .foregroundColor: UIColor.Text.dark,
                .paragraphStyle : paragraphStyle,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: "terms_of_service_key".localize(),
            replaceTextAttributes: [
                .link: tosDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: "privacy_policy_key".localize(),
            replaceTextAttributes: [
                .link: ppDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: "Contact Us",
            replaceTextAttributes: [
                .link: ppDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: "F.A.Q",
            replaceTextAttributes: [
                .link: ppDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        privacyTextView.attributedText = attributedString
    }
    
    // MARK: Actions
    @objc private func connectButtonTapped(_ sender: UIButton) {
        delegate?.changeStateTapped()
    }
    
    @objc private func locationButtonTapped (_ sender: UIControl) {
        delegate?.locationButtonTapped()
    }
    
    @objc private func goProButtonTapped (_ sender: UIControl) {
        delegate?.goProButtonTapped()
    }
    
    @objc private func getFreeTapped (_ sender: UIControl) {
        delegate?.getFreeTapped()
    }
    
}

extension MainScreenView {
    public func setUserInteraction(state: ConnectionState) {
        self.isUserInteractionEnabled = state.getUserInteraction()
    }
    public func setStateLabel(state: ConnectionState) {
        connectionStateLabel.text = state.getText()
    }
    public func setState(state: ConnectionState) {
        backgroundImageView.image = state.getBgWorldUIImage()
        centerButton.setImage(state.getCenterButtonUIImage(), for: .normal)
        connectionStateLabel.textColor = state.getUIColor()
        connectionStateLabel.text = state.getText()
        isUserInteractionEnabled = state.getUserInteraction()
        topLogoImageView.image = state.getTopLogoImage()
    }

    // MARK: - Selected Location View
    public func setLocationFlag(countryCode: String?) {
        locationButton.set(flagImageCountryCode: countryCode)
    }
    public func setLocationCountry(text: String?) {
        locationButton.set(country: text)
    }
    public func setLocationIP(text: String?) {
        locationButton.set(ip: text)
    }
    public func setLocationSignal(level: Int?) {
        let signalLevel = level ?? 3
        locationButton.set(signalImage: SignalLevel(rawValue: signalLevel)?.getSignalImage())
    }
    public func setGetFreeView(isHidden: Bool) {
        getFreeLabel.isHidden = isHidden
        getFreeAnimation.isHidden = isHidden
    }

}
