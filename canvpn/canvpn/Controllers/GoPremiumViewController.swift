//
//  GoPremiumViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class GoPremiumViewController: UIViewController {
    
    private lazy var goPreView = GoPremiumView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(goPreView)
        goPreView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
