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
        
        view.backgroundColor = UIColor.red
        
        firstViewController = FirstLandingViewController()
        secondViewController = SecondLandingViewController()
        thirdViewController = ThirdLandingViewController()
        
        firstViewController.delegate = self
        secondViewController.delegate = self
        thirdViewController.delegate = self
        
        startPresentation()
    }
    
    func startPresentation() {
        
        present(firstViewController, animated: true)
    }
}

extension LandingViewController: FirstLandingDelegate, SecondLandingDelegate, ThirdLandingDelegate {
    func goNextFromFirst() {
        firstViewController.dismiss(animated: true) {
            // Present the second view controller
            self.secondViewController.modalPresentationStyle = .fullScreen
            self.present(self.secondViewController, animated: true)
        }
    }
    
    func goNextFromSecond() {
        secondViewController.dismiss(animated: true) {
            // Present the third view controller
            self.thirdViewController.modalPresentationStyle = .fullScreen
            self.present(self.thirdViewController, animated: true)
        }
    }
    
    func goNextFromThird() {
        thirdViewController.dismiss(animated: true) {
            // Continue with your app flow
        }
    }
    
}
