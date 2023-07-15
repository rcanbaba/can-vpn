//
//  SplashScreenView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import UIKit
import Lottie
import SnapKit

protocol SplashScreenViewDelegate: AnyObject {
    func splashAnimationCompleted()
}

class SplashScreenView: UIView {
    
    public weak var delegate: SplashScreenViewDelegate?
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "splash-animation")
        animation.loopMode = .playOnce
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
        self.backgroundColor = UIColor.white
        
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(400)
        }
        
        animationView.play { [weak self] _ in
            self?.delegate?.splashAnimationCompleted()
        }
    }
}
