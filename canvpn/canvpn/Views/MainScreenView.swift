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
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "layered-waves-haikei")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var currentIPTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.Text.white
        label.textAlignment = .center
        label.text = "Current IP"
        return label
    }()
    
    private lazy var currentIPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.Text.white
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "176.33.101.137", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return label
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "")
        return animation
    }()
    
    private lazy var connectionStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = UIColor.Custom.orange
        button.addTarget(self, action: #selector(connectButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }()
    
    public lazy var serverListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ServerListTableViewCell.self, forCellReuseIdentifier: "ServerListTableViewCell")
        tableView.rowHeight = 40
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 3.0
        tableView.layer.borderColor = UIColor(red: 255/255, green: 111/255, blue: 97/255, alpha: 1.0).cgColor
        tableView.layer.cornerRadius = 10.0
        return tableView
    }()
    
    private lazy var tableViewBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Uygulamayı kullanarak Kullanım Şartları ve Gizlilik Politikası kabul etmiş olursunuz.", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
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
        
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(currentIPLabel.snp.bottom).inset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(animationView.snp.width)
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
        
        self.addSubview(instructionLabel)
        instructionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.addSubview(serverListTableView)
        serverListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(connectButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(55)
            make.bottom.equalTo(instructionLabel.snp.top).inset(-50)
        }
        
//        self.addSubview(tableViewBackView)
//        tableViewBackView.snp.makeConstraints { (make) in
//            make.size.equalTo(serverListTableView.snp.size)
//            make.leading.equalTo(tal)
//        }
        
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
        connectionStateLabel.text = " " + text + " "
    }
    
    public func setAnimation(name: String) {
        animationView.animation = LottieAnimation.named(name)
    }
    public func playAnimation(loopMode: LottieLoopMode) {
        animationView.loopMode = loopMode
        animationView.play()
    }
    public func setAnimation(isHidden: Bool) {
        animationView.isHidden = isHidden
    }
    
    public func setButtonText(text: String) {
        connectButton.setTitle(text, for: .normal)
    }
    
    public func setButton(isHidden: Bool) {
        connectButton.isHidden = isHidden
    }
}
