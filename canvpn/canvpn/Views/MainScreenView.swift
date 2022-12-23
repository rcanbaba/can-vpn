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
        imageView.image = UIImage(named: "layered-waves-bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public lazy var stateView: ConnectionStateView = {
        let view = ConnectionStateView()
        return view
    }()
    
    private lazy var currentIPTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Current IP"
        return label
    }()
    
    private lazy var currentIPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "176.33.101.137", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stateView.delegate = self
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
        
        self.addSubview(stateView)
        stateView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(currentIPTitleLabel)
        currentIPTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(currentIPLabel)
        currentIPLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentIPTitleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(serverListTableView)
        serverListTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(500)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
//        self.addSubview(tableViewBackView)
//        tableViewBackView.snp.makeConstraints { (make) in
//            make.size.equalTo(serverListTableView.snp.size)
//            make.leading.equalTo(tal)
//        }
        
        self.addSubview(instructionLabel)
        instructionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
    }
    
}

extension MainScreenView {
//    public func setUserInteraction(isEnabled: Bool) {
//        stateView.setUserInteraction(isEnabled: isEnabled)
//    }
//
//    public func setAnimation(name: String) {
//        stateView.setAnimation(name: name)
//    }
//
//    public func setStateLabel(text: String) {
//        stateView.setStateLabel(text: text)
//    }
}


extension MainScreenView: ConnectionStateViewDelegate {
    func buttonTapped() {
        delegate?.changeStateTapped()
    }
}
