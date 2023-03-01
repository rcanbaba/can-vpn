//
//  GoPremiumView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class GoPremiumView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "I Love VPN Premium"
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "No commitment, cancel anytime."
        return label
    }()
    
    private lazy var option1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "- Worldwide location"
        return label
    }()
    
    private lazy var option2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "- Faster connection"
        return label
    }()
    
    private lazy var option3Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "- No ads"
        return label
    }()
    
    private lazy var option4Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "- Military grade security"
        return label
    }()
    
    private lazy var freeTrialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Start 3 days free trial then"
        return label
    }()
    
    private lazy var subscriptionBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.white
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var firstProductView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.Custom.orange
        view.layer.applySketchShadow()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstProductTapped(_:))))
       // view.alpha = 1.0
        return view
    }()
    
    private lazy var secondProductView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.Custom.orange
        view.layer.applySketchShadow()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondProductTapped(_:))))
       // view.alpha = 1.0
        return view
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.Text.white, for: .normal)
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor.Custom.orange
        button.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.layer.applySketchShadow()
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(60)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10.0
        
        stackView.addArrangedSubview(option1Label)
        stackView.addArrangedSubview(option2Label)
        stackView.addArrangedSubview(option3Label)
        stackView.addArrangedSubview(option4Label)
                
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(90)
            make.centerX.equalToSuperview()
        }
        
        addSubview(subscribeButton)
        subscribeButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        addSubview(subscriptionBackView)
        subscriptionBackView.snp.makeConstraints { make in
            make.bottom.equalTo(subscribeButton.snp.top).inset(-80)
            make.centerX.equalToSuperview()
            make.height.equalTo(160)
            make.width.equalTo(320)
        }
        
        subscriptionBackView.addSubview(secondProductView)
        secondProductView.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.width.equalTo(150)
            make.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        
        subscriptionBackView.addSubview(firstProductView)
        firstProductView.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.width.equalTo(150)
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
        }
        
        addSubview(freeTrialLabel)
        freeTrialLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(subscriptionBackView.snp.top).inset(-60)
        }
    }
    
    @objc private func subscribeButtonTapped(_ sender: UIButton) {
        subscribeButton.shake()
    }
    
    @objc private func firstProductTapped (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.firstProductView.alpha = 1.0
            self.firstProductView.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            self.firstProductView.transform = CGAffineTransform(translationX: 10, y: -20)
           
        }
    }
    
    @objc private func secondProductTapped (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.secondProductView.alpha = 1.0
            self.secondProductView.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            self.secondProductView.transform = CGAffineTransform(translationX: 10, y: -20)
            self.firstProductView.transform = CGAffineTransform(scaleX: 0.9, y: 0.8)
            self.firstProductView.transform = CGAffineTransform(translationX: -10, y: 20)
        }
    }
    
    public func shakeButton() {
        subscribeButton.shake()
    }
    
}
