//
//  Toaster.swift
//  canvpn
//
//  Created by Can Babaoğlu on 3.04.2023.
//

import UIKit

class Toaster {
    
    public static func showToast(message : String) {
        UIApplication.getMainWindow { window in
            guard let window = window else { return }
            
            DispatchQueue.main.async {
                let backView = UIView()
                backView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
                backView.layer.cornerRadius = 12
                backView.clipsToBounds = true
                backView.layer.zPosition = 1
                
                window.addSubview(backView)
                backView.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.leading.trailing.equalToSuperview().inset(10)
                }
                
                let toastLabel = UILabel()
                toastLabel.textAlignment = .center
                toastLabel.font = UIFont.systemFont(ofSize: 14)
                toastLabel.text = message
                toastLabel.textColor = UIColor.white
                toastLabel.numberOfLines = 0
                toastLabel.lineBreakMode = .byWordWrapping
                
                backView.addSubview(toastLabel)
                toastLabel.snp.makeConstraints { (make) in
                    make.leading.trailing.equalToSuperview().inset(10)
                    make.top.bottom.equalToSuperview().inset(10)
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    backView.removeFromSuperview()
                }
            }
        }
    }
}

