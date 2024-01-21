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
        setControllers()
        setPresentations()
        setData()
        startPresentation()
    }
    
    private func setControllers() {
        firstViewController = FirstLandingViewController()
        secondViewController = SecondLandingViewController()
        thirdViewController = ThirdLandingViewController()
        
        firstViewController.delegate = self
        secondViewController.delegate = self
        thirdViewController.delegate = self
    }
    
    private func setPresentations() {
        firstViewController.modalTransitionStyle = .crossDissolve
        secondViewController.modalTransitionStyle = .crossDissolve
        thirdViewController.modalTransitionStyle = .crossDissolve
        
        firstViewController.modalPresentationStyle = .overFullScreen
        secondViewController.modalPresentationStyle = .overFullScreen
        thirdViewController.modalPresentationStyle = .overFullScreen
    }
    
    private func setData() {
        let firstLandingData = LandingData(
            title: "First",
            description: "DExc asdasdasd 1",
            centerImage: UIImage(named: "landing-img-1"),
            stepImage: UIImage(named: "landing-step-1")
        )
        let secondLandingData = LandingData(
            title: "Second",
            description: "DEx123 123 213213 213c 1",
            centerImage: UIImage(named: "landing-img-2"),
            stepImage: UIImage(named: "landing-step-2")
        )
        let thirdLandingData = LandingData(
            title: "Third",
            description: "DExaksdkaskd askdak kads ka sksakc 1",
            centerImage: UIImage(named: "landing-img-3"),
            stepImage: UIImage(named: "landing-step-3")
        )
        
        firstViewController.set(data: firstLandingData)
        secondViewController.set(data: secondLandingData)
        thirdViewController.set(data: thirdLandingData)
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

struct LandingData {
    var title: String
    var description: String
    var centerImage: UIImage?
    var stepImage: UIImage?
}
