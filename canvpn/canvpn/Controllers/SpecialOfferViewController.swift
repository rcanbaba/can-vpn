//
//  SpecialOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.04.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

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
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "special-offer-image")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.2
        return imageView
    }()
    
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .medium)
        label.textColor = .orange // Adjust the color as per your design
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = "Special Offer"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "1 Month Unlimited Access With %50 Off"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Special Offer".localize(), for: .normal)
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
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.closeButton.alpha = 1
            }
        }
    }
    
    private func configureUI() {
        view.addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(48)
            make.trailing.equalToSuperview().inset(64)
        }
        
        view.addSubview(countdownLabel)
        countdownLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.top.equalTo(countdownLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(48)
        }

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(48)
            make.trailing.equalToSuperview().inset(10)
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
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        delegate?.getButtonTapped(view: self)
        dismiss(animated: true)
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeButtonTapped(view: self)
        dismiss(animated: true)
    }
}
