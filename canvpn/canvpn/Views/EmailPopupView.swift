//
//  EmailPopupView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 6.09.2023.
//

import UIKit
import SnapKit

class EmailPopupView: UIView {
    
    // Initialize UI components such as labels, buttons, etc.
    let label: UILabel = {
        let label = UILabel()
        label.text = "Popup Message"
        label.textAlignment = .center
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    // Override the initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up the background color
        self.backgroundColor = .white
        
        // Add subviews
        addSubview(label)
        addSubview(closeButton)
        
        // Setup constraints using SnapKit
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up constraints using SnapKit
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(20)
        }
    }
}
