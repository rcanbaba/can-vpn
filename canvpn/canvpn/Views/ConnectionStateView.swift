//
//  ConnectionStateView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import Lottie
import SnapKit

class ConnectionStateView: UIView {
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.gray.cgColor
        return label
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "globeLoading")
        animation.loopMode = .loop
        //animation.isHidden = true
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        animationView.play()
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview()
        }
    }
}

extension ConnectionStateView {
    
    public func setUserInteraction(isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
    }
    
    public func setAnimation(name: String) {
        animationView.animation = LottieAnimation.named(name)
    }
    
    public func setStateLabel(text: String) {
        stateLabel.text = " " + text + " "
    }
    
    public func setAnimation(isHidden: Bool) {
        animationView.isHidden = isHidden
    }
    
    
}
