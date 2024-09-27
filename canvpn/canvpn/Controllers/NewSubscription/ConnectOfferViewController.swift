//
//  ConnectOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class ConnectOfferViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "back-offer-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    private lazy var topBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NewSubs.green
        return view
    }()
    
    private lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NewSubs.green
        return view
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "connect-offer-top-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "Boost Your Speed1".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "You're on a slower connection right now. Upgrade to Premium for lightning-fast browsing.2".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var getButton: NewOfferButton = {
        let view = NewOfferButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "Boost Now".localize()
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
    
    private let testimonials: [(name: String, message: String)] = [
        ("Sarah L.", "Tremendous speed! I can connect to any server instantly. 很好的应用！"),
        ("David12", "Sehr gute App, besonders für sicheres Surfen. Schnelle Verbindung."),
        ("Yasmin K.", "التطبيق ممتاز ولكن أحيانًا يتباطأ الاتصال."),
        ("Ling W.", "Great app, fast and secure. 完美的应用程序，特别推荐！"),
        ("Oliver H.", "Excellent value for money. Schneller und zuverlässiger Service."),
        ("Amelia R.", "Amazing performance, especially for the price. So glad I upgraded!"),
        ("Ahmad92", "برنامج رائع ولكن واجهت بعض المشاكل في الاتصال."),
        ("Hannah G.", "Perfect app for privacy and fast browsing! Ich benutze es täglich."),
        ("Zhao Y.", "速度非常快，连接稳定，非常满意。"),
        ("Isabella M.", "Sicher und zuverlässig! Besonders zufrieden mit der Geschwindigkeit."),
        ("Liam P.", "Fast, secure, and easy to use! 推荐大家使用这个VPN，非常棒！"),
        ("Karim S.", "التطبيق جيد لكن يحتاج بعض التحسينات في الاتصال."),
        ("Sophia K.", "Ich habe zu Premium gewechselt, und es ist fantastisch!"),
        ("Javier R.", "Aplicación muy rápida, fácil de usar y altamente recomendada."),
        ("Emily R.", "Incredibly fast! I noticed the difference as soon as I upgraded to premium."),
        ("Alex M.", "Sehr gutes VPN, besonders die schnelle Verbindung beeindruckt mich."),
        ("Fatima Z.", "تطبيق ممتاز! سرعة عالية وأمان."),
        ("Lucas T.", "Fast speeds, easy to use, and great support. Ich empfehle es jedem."),
        ("Mei Lei", "使用起来非常方便，速度快，非常推荐这个应用！"),
        ("JohnBose", "Amazing performance, especially for the price. So glad I upgraded!"),
        ("nina19244", "Fantastic for streaming and secure browsing! 速度非常快，非常推荐这个VPN。"),
        ("Omar H.", "أفضل تطبيق VPN جربته! سريع وآمن.")
    ]

    
    private var circularTestimonials: [(name: String, message: String)] {
        return testimonials + testimonials + testimonials
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 164, height: 132)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TestimonialCell.self, forCellWithReuseIdentifier: TestimonialCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var productView: NewProductView = {
        let view = NewProductView()
        return view
    }()
    
    override func viewDidLoad() {
        Analytics.logEvent("ConnectOfferPresented", parameters: [:])
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionViewScroll()
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
    
    private func setupCollectionViewScroll() {
        let middleIndexPath = IndexPath(item: 5, section: 0)
        collectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func configureUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(topBaseView)
        topBaseView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(240) // bottom inset fixed!!
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // MARK: - scrollable
        contentView.addSubview(topBackView)
        contentView.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        topBackView.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.bottom.equalTo(topImageView.snp.bottom).inset(5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(topImageView.snp.bottom).inset(6)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(35)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(132)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20) // content view bottom
        }
        
        // Fixed bottom views
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
        stackView.spacing = 16
        
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
        
        // Add the close button
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(24)
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
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

extension ConnectOfferViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return circularTestimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestimonialCell.reuseIdentifier, for: indexPath) as! TestimonialCell
        let testimonial = circularTestimonials[indexPath.item]
        cell.configure(with: testimonial.name, message: testimonial.message)
        return cell
    }
    
}
