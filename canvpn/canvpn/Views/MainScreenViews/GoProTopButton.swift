//
//  GoProTopButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 2.12.2023.
//

import UIKit

class GoProTopButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.white.withAlphaComponent(0.5) : UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    private lazy var premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "go-pro-image")
        return imageView
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "go-pro-right-arrow")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        layer.cornerRadius = 12
        layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
 //       layer.borderWidth = 2.0
 //       layer.borderColor = UIColor.Custom.goPreButtonGold.withAlphaComponent(0.7).cgColor
        
        addSubview(premiumImageView)
        premiumImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
}

// MARK: - public methods
extension GoProTopButton {
    public func setState(isPremium: Bool) {

    }

}
