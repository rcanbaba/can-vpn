//
//  LandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

class LandingViewController: UIViewController {

    var firstViewController: FirstLandingViewController!
    var secondViewController: SecondLandingViewController!
    var thirdViewController: ThirdLandingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        firstViewController = FirstLandingViewController()
        secondViewController = SecondLandingViewController()
        thirdViewController = ThirdLandingViewController()
        
        firstViewController.delegate = self
        secondViewController.delegate = self
        thirdViewController.delegate = self
        
        firstViewController.modalTransitionStyle = .crossDissolve
        secondViewController.modalTransitionStyle = .crossDissolve
        thirdViewController.modalTransitionStyle = .crossDissolve
        
        firstViewController.modalPresentationStyle = .overFullScreen
        secondViewController.modalPresentationStyle = .overFullScreen
        thirdViewController.modalPresentationStyle = .overFullScreen
        
        startPresentation()
    }
    
    func startPresentation() {
        present(firstViewController, animated: true)
    }
}

extension LandingViewController: FirstLandingDelegate, SecondLandingDelegate, ThirdLandingDelegate {
    func goNextFromFirst() {
        firstViewController.dismiss(animated: true) {
            self.present(self.secondViewController, animated: true)
        }
    }
    
    func goNextFromSecond() {
        secondViewController.dismiss(animated: true) {
            self.present(self.thirdViewController, animated: true)
        }
    }
    
    func goNextFromThird() {
        thirdViewController.dismiss(animated: true) {

        }
    }
    
}
