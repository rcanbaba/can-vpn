//
//  MainScreenView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.12.2022.
//

import UIKit
import Lottie
import SnapKit

protocol MainScreenViewDelegate: AnyObject {
    func changeStateTapped()
}

class MainScreenView: UIView {
    
    public weak var delegate: MainScreenViewDelegate?
    
    public lazy var navigationBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.orange
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-bg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var currentIPTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.Text.dark
        label.textAlignment = .center
        label.text = "current_ip_key".localize()
        return label
    }()
    
    private lazy var currentIPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.Text.dark
        label.textAlignment = .center
        return label
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "")
        animation.animation = LottieAnimation.named("globe_loading")
        animation.loopMode = .loop
        animation.isHidden = true
        return animation
    }()
    
    private lazy var secondAnimationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "")
        animation.animation = LottieAnimation.named("vpn_connected")
        animation.loopMode = .loop
        animation.isHidden = true
        animation.contentMode = .scaleAspectFit
        return animation
    }()
    
    private lazy var connectionStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.Text.dark
        label.textAlignment = .center
        return label
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.Text.dark, for: .normal)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = UIColor.Custom.orange
        button.addTarget(self, action: #selector(connectButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.applySketchShadow()
        return button
    }()
    
    public lazy var serverListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ServerListTableViewCell.self, forCellReuseIdentifier: "ServerListTableViewCell")
        tableView.rowHeight = 40
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        tableView.layer.borderWidth = 3.0
        tableView.layer.borderColor = UIColor.Custom.orange.cgColor
        tableView.layer.cornerRadius = 10.0
        tableView.layer.applySketchShadow()
        return tableView
    }()
    
    private lazy var tableViewBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(navigationBarBackgroundView)
        navigationBarBackgroundView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(backgroundImageView)
        
        self.addSubview(currentIPTitleLabel)
        currentIPTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        self.addSubview(currentIPLabel)
        currentIPLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentIPTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(currentIPLabel.snp.bottom).offset(20)
        }
        
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(currentIPLabel.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(animationView.snp.width)
        }
        
        self.addSubview(secondAnimationView)
        secondAnimationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(600)
            make.height.equalTo(secondAnimationView.snp.width)
        }
        
        self.addSubview(connectionStateLabel)
        connectionStateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(connectButton)
        connectButton.snp.makeConstraints { (make) in
            make.top.equalTo(connectionStateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
        
        self.addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(serverListTableView)
        serverListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(connectButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(55)
            make.bottom.equalTo(privacyTextView.snp.top).inset(-50)
        }
        
//        self.addSubview(tableViewBackView)
//        tableViewBackView.snp.makeConstraints { (make) in
//            make.size.equalTo(serverListTableView.snp.size)
//            make.leading.equalTo(tal)
//        }
        
        setPrivacyText ()
    }
    
    private func setPrivacyText () {
        let baseString = "pp_tos_key".localize()
        let ppDefaultUrl = Constants.appPrivacyPolicyPageURLString
        let tosDefaultUrl = Constants.appTermsOfServicePageURLString
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
        
        privacyTextView.attributedText = attributedString
    }
    
    // MARK: Actions
    @objc private func connectButtonTapped(_ sender: UIButton) {
        delegate?.changeStateTapped()
    }
    
}

extension MainScreenView {
    public func setUserInteraction(isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
    }
    public func setStateLabel(text: String) {
        connectionStateLabel.text = text
    }
    public func setAndPlayAnimation(isConnecting: Bool) {
        animationView.isHidden = !isConnecting
        secondAnimationView.isHidden = isConnecting
        if isConnecting {
            animationView.play()
        } else {
            secondAnimationView.play()
        }
    }
    public func stopAnimation(isConnecting: Bool) {
        if isConnecting {
            animationView.isHidden = true
            animationView.stop()
        } else {
            secondAnimationView.isHidden = true
            secondAnimationView.stop()
        }
    }
    public func hideAnimationView() {
        animationView.isHidden = true
        secondAnimationView.isHidden = true
    }
    public func setButtonText(text: String) {
        connectButton.setTitle(text, for: .normal)
    }
    public func setButton(isHidden: Bool) {
        connectButton.isHidden = isHidden
    }
    public func setIpAdress(text: String){
        currentIPLabel.attributedText = NSAttributedString(string: text, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    public func setColor(_ color: UIColor) {
        navigationBarBackgroundView.backgroundColor = color
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.connectButton.backgroundColor = color
            self?.serverListTableView.backgroundColor = color.withAlphaComponent(0.3)
            self?.serverListTableView.layer.borderColor = color.cgColor
            self?.tableViewBackView.backgroundColor = color.withAlphaComponent(0.6)
        }
    }
    public func reloadTableView() {
        serverListTableView.reloadData()
    }
    
}
