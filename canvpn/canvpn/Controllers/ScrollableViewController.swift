//
//  ScrollableViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 25.01.2024.
//

import UIKit

class ScrollableViewController: UIViewController {
    
    lazy var rootScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()
    
    lazy var baseView: UIView = {
        var view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rootScrollView)
        rootScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        rootScrollView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalTo(rootScrollView)
            make.width.equalTo(view)
            make.height.equalTo(view).priority(250)
        }
    }
}
