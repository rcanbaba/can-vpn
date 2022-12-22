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
