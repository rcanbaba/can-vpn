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
    func stateViewTapped()
}

class MainScreenView: UIView {
    
    public weak var delegate: MainScreenViewDelegate?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "layered-waves-bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stateView: ConnectionStateView = {
        let view = ConnectionStateView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateViewTapped(_:))))
        return view
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
        
        self.addSubview(stateView)
        stateView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
    }
    
    //MARK: - ACTIONS
    @objc private func stateViewTapped (_ sender: UITapGestureRecognizer) {
        delegate?.stateViewTapped()
    }
}

extension MainScreenView {
    public func setUserInteraction(isEnabled: Bool) {
        stateView.setUserInteraction(isEnabled: isEnabled)
    }
    
    public func setAnimation(name: String) {
        stateView.setAnimation(name: name)
    }
    
    public func setStateLabel(text: String) {
        stateView.setStateLabel(text: text)
    }
}
