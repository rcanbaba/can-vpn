//
//  TimerOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 16.09.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class TimerOfferViewController: UIViewController {
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "back-offer-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.gradientLayer.colors = [
            UIColor.NewSubs.orange.cgColor,
            UIColor.NewSubs.orangish.cgColor
        ]
        return gradientView
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discount-top-img")
        imageView.contentMode = .bottom
        return imageView
    }()
    
    private lazy var topCenterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discount-center-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NewSubs.green
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "Limited Time Offer".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var getButton: NewOfferButton = {
        let view = NewOfferButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "Start Subscription".localize()
        view.setOrangeUI()
        return view
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Use"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy Policy"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var lineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vertical-line")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var productView: NewProductView = {
        let view = NewProductView()
        view.setOrangeUI()
        return view
    }()
    
    override func viewDidLoad() {
        Analytics.logEvent("ConnectOfferPresented", parameters: [:])
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGestureRecognizer()
        activateCloseButtonTimer()
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureUI() {
        view.addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.height.equalTo(240)
        }
        
        view.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.bottom.equalTo(backGradientView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(topCenterImageView)
        topCenterImageView.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backGradientView.snp.bottom).offset(64)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(topCenterImageView.snp.bottom).offset(20)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(24)
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
        }
        
        view.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(65)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        getButton.layer.applySketchShadow()
        
        view.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(93)
            make.bottom.equalTo(getButton.snp.top).inset(-24)
        }
        
        let stackView = UIStackView(arrangedSubviews: [termsLabel, privacyLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16 // Adjust spacing as needed
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(getButton.snp.bottom).offset(20)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(2)
        }

        
    }
    
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        showCloseAlert()
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        // TODO: can
        //   self.subscribeOffer()
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        showSubscriptionTerms()
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        showPrivacyPage()
    }
    
    private func showCloseAlert() {
        let alertController = UIAlertController(
            title: "offer_alert_title".localize(),
            message: "offer_alert_message".localize(),
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: "offer_alert_cancel".localize(),
            style: .default
        ) { (action) in
            self.dismiss(animated: true)
        }

        let tryNowAction = UIAlertAction(
            title: "offer_alert_try".localize(),
            style: .default
        ) { (action) in
            Analytics.logEvent("SpecialOfferSubsTappedFromAlert", parameters: [:])
            // TODO:
         //   self.subscribeOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tryNowAction.setValue(UIColor.green, forKey: "titleTextColor")

        present(alertController, animated: true)
    }
    
    private func showSubscriptionTerms() {
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showPrivacyPage() {
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        guard let url = URL(string: ppDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.closeButton.alpha = 1
            }
        }
    }
    
}
