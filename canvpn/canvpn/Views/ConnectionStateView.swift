//
//  ConnectionStateView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import Lottie
import SnapKit

protocol ConnectionStateViewDelegate: AnyObject {
    func buttonTapped()
}

class ConnectionStateView: UIView {
    
    public weak var delegate: ConnectionStateViewDelegate?
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "")
        return animation
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(150)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        self.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(stateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
    }
    
    // MARK: Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.buttonTapped()
    }
}

extension ConnectionStateView {
    
    public func setUserInteraction(isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
    }
    
    public func setStateLabel(text: String) {
        stateLabel.text = " " + text + " "
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
        button.setTitle(text, for: .normal)
    }
    
    public func setButton(isHidden: Bool) {
        button.isHidden = isHidden
    }
    
}
