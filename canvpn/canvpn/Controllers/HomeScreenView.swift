//
//  HomeScreenView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 27.11.2023.
//

import UIKit
import SnapKit
import Lottie
import MapKit

protocol HomeScreenViewDelegate: AnyObject {
    func changeStateTapped()
    func goProButtonTapped()
}

class HomeScreenView: UIView {
    
    public weak var delegate: HomeScreenViewDelegate?
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "IP: "
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stateLabel, ipLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(type: .system)
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
    
    public lazy var goProButton: GoProTopButton = {
        let button = GoProTopButton()
        button.addTarget(self, action: #selector(goProButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return view
    }()
    
    public lazy var mapView = MKMapView()
    public lazy var pickerView = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let topOffset = UIScreen.main.bounds.height / 11.7
        
        addSubview(topView)
        
        addSubview(topLogoImageView)
        topLogoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.7)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(topLogoImageView.snp.bottom).offset(12)
        }
        
        addSubview(goProButton)
        goProButton.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(topLogoImageView.snp.centerY)
        }
        
        addSubview(bottomView)
        addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        setPrivacyText()
        
        
        pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        addSubview(centerButton)
        centerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5.0)
            make.height.equalTo(centerButton.snp.width)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(privacyTextView.snp.top).inset(-12)
        }
        
        addSubview(pickerView)
        pickerView.layer.cornerRadius = 12
        pickerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(80)
            make.centerY.equalTo(centerButton.snp.centerY)
            make.trailing.equalTo(centerButton.snp.leading).inset(-12)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalTo(pickerView.snp.top).inset(-12)
        }
        
    }
    
    private func setPrivacyText () {
        let baseString = "pp_tos_key".localize() + " " + "FAQ_contactUs_key".localize()
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        let tosDefaultUrl = SettingsManager.shared.settings?.links.termsURL ?? Constants.appTermsOfServicePageURLString
        let faqDefaultUrl = SettingsManager.shared.settings?.links.faqsURL ?? Constants.appFAQPageURLString
        
        let contactMailDefault = SettingsManager.shared.settings?.contactUs.email ?? Constants.appContactUsMailString
        let contactMailSubject = SettingsManager.shared.settings?.contactUs.subject
        let contactUsDefaultUrl = MailToURLGenerator.generateMailToURL(email: contactMailDefault, subject: contactMailSubject)
        
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
            replaceText: "FAQ_key".localize(),
            replaceTextAttributes: [
                .link: faqDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        attributedString = AttributedTextHelper.replaceAttributedString(
            attributedString: attributedString,
            replaceText: "contactUs_key".localize(),
            replaceTextAttributes: [
                .link: contactUsDefaultUrl as Any,
                .font: UIFont.boldSystemFont(ofSize: 10)
            ]
        )
        
        privacyTextView.attributedText = attributedString
    }
    
    // MARK: Actions
    @objc private func connectButtonTapped(_ sender: UIButton) {
        delegate?.changeStateTapped()
    }

    @objc private func goProButtonTapped (_ sender: UIControl) {
        delegate?.goProButtonTapped()
    }
}

// MARK: Public methods
extension HomeScreenView {
    public func setState(state: ConnectionState) {
        centerButton.setImage(state.getCenterButtonUIImage(), for: .normal)
        stateLabel.textColor = state.getUIColor()
        stateLabel.text = state.getText()
        isUserInteractionEnabled = state.getUserInteraction()
        mapView.isUserInteractionEnabled = state.getUserInteraction()
        pickerView.isUserInteractionEnabled = state.getUserInteraction()
        topLogoImageView.image = state.getTopLogoImage()
    }
    
    public func setIpLabel(text: String) {
        ipLabel.text = "IP: " + text
    }
    
    public func shakeGoProButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
            shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            shake.values = [8, -8, 4, -4, 2, -2, 0]
            shake.duration = 0.6
            shake.repeatCount = 1
            self?.goProButton.layer.add(shake, forKey: "shake")
        }
    }
}
