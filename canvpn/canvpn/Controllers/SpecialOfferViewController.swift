//
//  SpecialOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.04.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

//TODO: ihtiyaç var mı?
protocol SpecialOfferViewControllerDelegate: AnyObject {
    func getButtonTapped(view: SpecialOfferViewController)
    func closeButtonTapped(view: SpecialOfferViewController)
}

class SpecialOfferViewController: UIViewController {
    
    public weak var delegate: SpecialOfferViewControllerDelegate?
    
    var countdownTimer: Timer!
    var remainingSeconds: Int = 0 {
        didSet {
            countdownLabel.text = formatTimeString(seconds: remainingSeconds)
        }
    }
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.text = "One Time Special Offer"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "offer-img-girl")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Get\n75% Off"
        return label
    }()
    
    private lazy var badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "must-have-badge")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var reviewCarouselImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "review-carousel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        label.textColor = .orange
        label.layer.applySketchShadow()
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var getButton: LandingButton = {
        let view = LandingButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "Try It Free"
        return view
    }()
    
    private lazy var termsLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .left
        label.text = "Terms of Use".localize()
        return label
    }()
    
    private lazy var privacyLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .right
        label.text = "Privacy Policy".localize()
        return label
    }()
    
    private lazy var offerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .center
        label.text = "Try free for 3 days, then € 1,99 per Week".localize()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setGestureRecognizer()
        activateCloseButtonTimer()
        startCountdown(from: 109)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("023SpecialOfferPresented", parameters: ["type" : "willAppear"])
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    private func configureUI() {
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        view.addSubview(backGradientView)
        view.addSubview(titleLabel)
        view.addSubview(backgroundImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(badgeImageView)
        view.addSubview(reviewCarouselImageView)
        view.addSubview(countdownLabel)
        view.addSubview(getButton)
        view.addSubview(offerLabel)
        view.addSubview(termsLabel)
        view.addSubview(privacyLabel)
        view.addSubview(closeButton)
        
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel).offset(-8)
            make.height.equalToSuperview().dividedBy(2.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().inset(48)
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(48)
            make.height.equalToSuperview().dividedBy(13)
        }
        
        reviewCarouselImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.width.equalToSuperview()
        }
        
        countdownLabel.snp.makeConstraints { make in
            make.bottom.equalTo(getButton.snp.top).inset(-48)
            make.centerX.equalToSuperview()
        }
        
        getButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
        offerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(getButton.snp.top).offset(-10)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(12)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(12)
        }

        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
        
        configureActivityIndicatorUI()
    }

    private func configureActivityIndicatorUI() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.closeButton.alpha = 1
            }
        }
    }
    
    func startCountdown(from seconds: Int) {
        remainingSeconds = seconds
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        } else {
            countdownTimer.invalidate()
            // Handle what happens when the timer reaches 0
        }
    }
    
    func formatTimeString(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    public func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.navigationItem.hidesBackButton = show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: ACTIONS
    @objc private func getButtonTapped(_ sender: UIButton) {
        subscribeOffer()
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        showCloseAlert()
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        showSubscriptionTerms()
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        showPrivacyPage()
    }
    
    private func showCloseAlert() {
        let alertController = UIAlertController(title: "Special Offer", message: "You are about to lose your special offer. Are you sure?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true)
        }

        let tryNowAction = UIAlertAction(title: "Try Now", style: .default) { (action) in
            self.subscribeOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tryNowAction.setValue(UIColor.green, forKey: "titleTextColor")

        present(alertController, animated: true)
    }
    
    private func subscribeOffer() {
        //TODO: start subs flow
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
}
