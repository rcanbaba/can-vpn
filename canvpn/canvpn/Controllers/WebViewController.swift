//
//  WebViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import WebKit
import Lottie

class WebViewController: UIViewController {
    
    private lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar.init()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.barTintColor = UIColor.white

        let close = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold)).withTintColor(UIColor.orange, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonTapped))

        let reload = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold)).withTintColor(UIColor.orange, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(self.reloadButtonTapped))

        let navItem = UINavigationItem.init()
        navItem.setRightBarButton(close, animated: false)
        navItem.setLeftBarButton(reload, animated: false)
        bar.setItems([navItem], animated: false)
        return bar
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading-icon-animation")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFill
        return animation
    }()
    
    var webView: WKWebView!
    var url : String = "https://www.google.com"
    
    class func getInstance(with url: String) -> WebViewController {
        let instance = WebViewController()
        instance.modalPresentationStyle = .overFullScreen
        instance.url = url
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsPictureInPictureMediaPlayback = true
        
        
        webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp.bottom)
        }
        
        if let url = URL (string: self.url) {
            webView.load(URLRequest(url: url))
            RatingCountManager.shared.incrementWebPresentedCount()
        }
        
        animationView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        animationView.center = view.center
        view.addSubview(animationView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadButtonTapped() {
        webView.reload()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // For instance, you can show an activity indicator here
        animationView.isHidden = false
        animationView.play()
        print("CAN - - STARTED")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop the activity indicator, if you added one
        animationView.isHidden = true
        animationView.stop()
        print("CAN - - STOPPED")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Handle error
        Toaster.showToast(message: "Error occurred, please reload.")
        animationView.isHidden = false
        animationView.stop()
        print("CAN - - FAILED")
    }
}
