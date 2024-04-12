//
//  LandingMainView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit
import SnapKit

protocol LandingMainViewDelegate: AnyObject {
    func nextTapped()
    func closeTapped()
    func termsTapped()
    func privacyTapped()
}

class LandingMainView: UIView {
    
    public weak var delegate: LandingMainViewDelegate?
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Landing.backGradientStart.cgColor,
            UIColor.Landing.backGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var landingButton: LandingButton = {
        let view = LandingButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(landingButtonTapped(_:))))
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.Landing.titleText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Landing.titleText.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "bordered-close-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .left
        label.text = "Terms of Use".localize()
        label.isHidden = true
        return label
    }()
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .right
        label.text = "Privacy Policy".localize()
        label.isHidden = true
        return label
    }()
    
    private lazy var offerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .center
        label.text = "3 gün beleş 5 gün 3 dolar".localize()
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.white
        
        addSubview(backGradientView)
        addSubview(topLogoImageView)
        addSubview(centerImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(stepImageView)
        addSubview(landingButton)
        addSubview(closeButton)
        addSubview(offerLabel)
        addSubview(termsLabel)
        addSubview(privacyLabel)
        
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.width.equalToSuperview().inset(80)
        }
        
        centerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(48)
            make.width.equalToSuperview().inset(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(48)
            make.top.equalTo(centerImageView.snp.bottom).offset(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(48)
        }
        
        landingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(64)
        }
        
        stepImageView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(landingButton.snp.top).offset(-24)
        }
        
        offerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(landingButton.snp.top).offset(-10)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(landingButton.snp.bottom).offset(12)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(landingButton.snp.bottom).offset(12)
        }
        //TODO set timer!!
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(48)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    @objc private func landingButtonTapped (_ sender: UITapGestureRecognizer) {
        delegate?.nextTapped()
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeTapped()
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.termsTapped()
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.privacyTapped()
    }

}

// MARK: Public methods
extension LandingMainView {
    public func setTitle(text: String) {
        titleLabel.text = text
    }
    public func setDescription(text: String) {
        descriptionLabel.text = text
    }
    public func setCenterImage(image: UIImage?) {
        centerImageView.image = image
    }
    public func setStep(image: UIImage?) {
        stepImageView.image = image
    }
    public func setButonText(text: String) {
        landingButton.textLabel.text = text
    }
    public func configureAsOfferView() {
        stepImageView.isHidden = true
        termsLabel.isHidden = false
        privacyLabel.isHidden = false
        offerLabel.isHidden = false
    }
}
