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
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Landing.backGradientStart.cgColor,
            UIColor.Landing.backGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var landingButton: LandingButton = {
        let view = LandingButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(landingButtonTapped(_:))))
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.Landing.titleText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Landing.titleText.withAlphaComponent(0.8)
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
        
        addSubview(backGradientView)
        addSubview(topLogoImageView)
        addSubview(centerImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(stepImageView)
        addSubview(landingButton)
        
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.width.equalToSuperview().inset(80)
        }
        
        centerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(48)
            make.width.equalToSuperview().inset(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(48)
            make.top.equalTo(centerImageView.snp.bottom).offset(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(48)
        }
        
        landingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(64)
        }
        
        stepImageView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(landingButton.snp.top).offset(-24)
        }
        
    }
    
    @objc private func landingButtonTapped (_ sender: UITapGestureRecognizer) {
        delegate?.nextTapped()
    }

}

// MARK: Public methods
extension LandingMainView {
    public func setTitle(text: String) {
        titleLabel.text = text
    }
    public func setDescription(text: String) {
        descriptionLabel.text = text
    }
    public func setCenterImage(image: UIImage?) {
        centerImageView.image = image
    }
    public func setStep(image: UIImage?) {
        stepImageView.image = image
    }
    public func setButonText(text: String) {
        landingButton.textLabel.text = text
    }
}
