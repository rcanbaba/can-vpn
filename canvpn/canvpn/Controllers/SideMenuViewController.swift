//
//  SideMenuViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import StoreKit

class SideMenuViewController: UIViewController {
    
    private let menuItems: [MenuItemType] = [
        .accountInformation, // ip adress - subs type
        .restoreSubscriptions, // yönlendir
        .subscriptionHistory, // VC yarat göster
        .usePromoCode, // yönlendir orda aç
        .shareUs,
        .rateUs,
        .aboutUs, // WEB
        .faq, // WEB
        .feedback, // WEB
        .checkSecurity, // ayrı bir popup
        .whatIsMyIP, // WEB
        .whatIsMySpeed, // WEB
        .settings, // VC -> language
        .blankItem,
        .blankItem,
        .blankItem,
        .version, // version
        .staySecureWithLove // Motto
    ]
    
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.95) // You can set any color you want

        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        view.addSubview(menuTableView)

        menuTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MenuCell")
        let menuItem = menuItems[indexPath.row]
        cell.imageView?.image = menuItem.getImage()
        cell.textLabel?.text = menuItem.getTitle()
        cell.textLabel?.textColor = UIColor.Custom.goPreGrayText
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
        
        switch selectedItem {
            
        case .shareUs:
            presentShareSheet()
            break
         
        case .rateUs:
            presentRateUs()
            break
            
        // Handle other cases here
        default:
            presentWebSheet(type: selectedItem)
            break
        }
    }
    
}

// MARK: - Menu operations
extension SideMenuViewController {
    
    func presentShareSheet() {
        let appLogo = UIImage(named: "top-logo-green")!
        let appLink = "https://appstore.com/yourapp" // Replace with your app's link
        let customMessage = "Check out \(Constants.appVisibleName)! I've been using it and it's been great. \(appLink)"
        
        let activityViewController = UIActivityViewController(activityItems: [customMessage, appLogo], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func presentWebSheet(type: MenuItemType) {
        let urlString = type.getURLString()
        let webVC = WebViewController.getInstance(with: urlString)
        self.present(webVC, animated: true, completion: nil)
    }
    
    func presentRateUs() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
}
