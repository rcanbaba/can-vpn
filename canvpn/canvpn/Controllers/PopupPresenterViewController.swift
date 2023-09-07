//
//  PopupPresenterViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 6.09.2023.
//

import UIKit

class PopupPresenterViewController: UIViewController {
    
    public var popupView: UIView? {
        didSet {
            guard let popupView = popupView else { return }
            view.addSubview(popupView)
            popupView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(200)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = popupView else {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            return
        }
    }
}
