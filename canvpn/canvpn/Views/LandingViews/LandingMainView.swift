//
//  LandingMainView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit
import SnapKit

protocol LandingMainViewDelegate: AnyObject {
    func nextTapped()
}

class LandingMainView: UIView {
    
    public weak var delegate: LandingMainViewDelegate?
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-green")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private lazy var subscribeButton: SubscriptionButton = {
        let view = SubscriptionButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(subscribeTapped(_:))))
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
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
        backgroundColor = UIColor.white
        
        addSubview(topLogoImageView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subscribeButton)
        
        
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.width.height.equalTo(100)
        }
        
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(24)
            make.width.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.top.equalTo(imageView.snp.bottom).offset(36)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
    }
    
    @objc private func subscribeTapped (_ sender: UITapGestureRecognizer) {
        delegate?.nextTapped()
    }
    
    public func setTitle(text: String) {
        titleLabel.text = text
    }
}
