//
//  RatingPopupViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.01.2024.
//

import UIKit

protocol RatingPopupViewControllerDelegate: AnyObject {
    func didTapRateButton(_ controller: RatingPopupViewController, rate: Int)
    func didTapCancelButton(_ controller: RatingPopupViewController)
}

class RatingPopupViewController: UIViewController {
    public weak var delegate: RatingPopupViewControllerDelegate?
    
    private var selectedItemImageName = "rating-star-selected"
    private var unselectedItemImageName = "rating-star-unselected"
    
    private var titleText: String?
    private var descriptionText: String?
    
    private var givenRating = -1
    
    private struct RatingItem {
        var header: String
        var description: String
        var ratingImageView: UIImageView
    }
    
    private lazy var ratingItems = { [
        // TODO: Localize
        RatingItem(header: "💩", description: "Terrible!", ratingImageView: generateStarImageView()),
        RatingItem(header: "🤨", description: "Ahhh?!", ratingImageView: generateStarImageView()),
        RatingItem(header: "👍", description: "OK!", ratingImageView: generateStarImageView()),
        RatingItem(header: "😌", description: "Fine!", ratingImageView: generateStarImageView()),
        RatingItem(header: "😍", description: "Excellent!", ratingImageView: generateStarImageView()),
    ] }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .black
        label.text = titleText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .Custom.RatingPopup.description
        label.text = descriptionText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal) // TODO: Localize
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        button.setTitleColor(.Custom.RatingPopup.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setBackgroundColor(color: UIColor.white, forState: .normal)
        button.setBackgroundColor(color: .Custom.RatingPopup.viewBackground, forState: .highlighted)
        return button
    }()
    
    private lazy var rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Rate", for: .normal) // TODO: Localize
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(rateButtonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setBackgroundColor(color: UIColor.white, forState: .normal)
        button.setBackgroundColor(color: .Custom.RatingPopup.viewBackground, forState: .highlighted)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, rateButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0)
        stackView.spacing = 1
        return stackView
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: ratingItems.map { $0.ratingImageView }
        )
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var windowWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.98)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelsFromWelcomeSettings()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        windowWrapperView.alpha = 0
        windowWrapperView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSelectAnimations(currentIndex: self.givenRating, selectedIndex: self.givenRating)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.windowWrapperView.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.windowWrapperView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.35)
        
        view.addSubview(windowWrapperView)
        windowWrapperView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
        }
        
        windowWrapperView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        windowWrapperView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        buttonsStackView.isHidden = true
        windowWrapperView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        buttonsStackView.arrangedSubviews.forEach { (button) in
            button.snp.makeConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        
        windowWrapperView.addSubview(starsStackView)
        starsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(buttonsStackView.snp.top).inset(-45)
        }
        
        ratingItems.forEach {
            $0.ratingImageView.snp.makeConstraints { (make) in
                make.size.equalTo(36)
            }
        }
    }
    
    private func performSelectAnimations(currentIndex: Int, selectedIndex: Int = -1) {
        var delay: TimeInterval = 0
        
        for (i, ratingItem) in ratingItems.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else {
                    return
                }
                
                var imageName = self.unselectedItemImageName
                
                if i <= selectedIndex {
                    imageName = self.selectedItemImageName
                    ratingItem.ratingImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
                else if i <= currentIndex || selectedIndex == -1 {
                    ratingItem.ratingImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                
                ratingItem.ratingImageView.image = UIImage(named: imageName)
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                    ratingItem.ratingImageView.transform = .identity
                }, completion: nil)
            }
            delay += 0.05
        }
    }
    
    private func expandButtonsStack() {
        buttonsStackView.arrangedSubviews.forEach { (button) in
            button.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
        }
        
        view.layoutIfNeeded()
    }
    
    private func generateStarImageView() -> UIImageView {
        let imageView = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starImageViewTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    private func starSelected(at index: Int) {
        performSelectAnimations(currentIndex: self.givenRating, selectedIndex: index)
        
        if self.givenRating == -1 {
            headerLabel.font = UIFont.systemFont(ofSize: 48)
            
            descriptionLabel.font = UIFont.systemFont(ofSize: 24)
            descriptionLabel.textColor = .black
            
            buttonsStackView.isHidden = false
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews, .allowAnimatedContent], animations: { [weak self] in
                self?.expandButtonsStack()
            }, completion: nil)
        }
        
        self.setTexts(for: index)
        self.givenRating = index
    }
    
    private func setTexts(for index: Int) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.transitionCrossDissolve],
                       animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.headerLabel.text = self.ratingItems[index].header
            self.descriptionLabel.text = self.ratingItems[index].description
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func dismissWithAnimation(completion: (() -> ())? = nil) {
        self.view.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.view.alpha = 0
        }, completion: { [weak self] (completed) in
            if completed {
                self?.dismiss(animated: false, completion: {
                    completion?()
                })
            }
        })
        
        self.windowWrapperView.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.windowWrapperView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }, completion: nil)
    }
    
    private func setLabelsFromWelcomeSettings() {
      //  let welcomeSettings = WelcomeSettingsManager.shared.welcomeSettings
        self.titleText = "Do you like \(Constants.appVisibleName)"
        self.descriptionText = "If you love our app, please take a moment to rate it!"
    }
}

extension RatingPopupViewController {
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        self.delegate?.didTapCancelButton(self)
    }
    
    @objc private func rateButtonTapped(_ sender: UIButton) {
        self.delegate?.didTapRateButton(self, rate: self.givenRating + 1)
    }
    
    @objc private func starImageViewTapped(_ sender: UITapGestureRecognizer) {
        ratingItems.enumerated().forEach { (index, item) in
            if item.ratingImageView == sender.view {
                starSelected(at: index)
                return
            }
        }
    }
}
