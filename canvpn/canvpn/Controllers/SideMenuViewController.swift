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
        view.backgroundColor = UIColor(white: 1, alpha: 0.95)

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
        cell.selectionStyle = .none
        cell.imageView?.image = menuItem.getImage()
        cell.textLabel?.text = menuItem.getTitle()
        cell.textLabel?.textColor = UIColor.Custom.goPreGrayText
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
        makeRelatedMenuOperation(type: selectedItem)
    }
    
}

// MARK: - Menu operations
extension SideMenuViewController {
    
    private func makeRelatedMenuOperation(type: MenuItemType) {
        switch type {
        case .accountInformation, .settings, .checkSecurity:
            presentViewController(type: type)
        case .restoreSubscriptions, .subscriptionHistory, .usePromoCode:
            presentSubscriptionFlow(type: type)
        case .rateUs:
            presentRateUs()
        case .feedback, .faq, .aboutUs, .whatIsMyIP, .whatIsMySpeed:
            presentWebSheet(type: type)
        case .shareUs:
            presentShareSheet()
        case .blankItem, .version, .staySecureWithLove:
            break
        }
    }
    
    private func presentViewController(type: MenuItemType) {
        switch type {
        case .accountInformation:
            let viewController = AccountViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case .checkSecurity:
            let viewController = SecurityCheckViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case .settings:
            let viewController = SettingsViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
    private func presentSubscriptionFlow(type: MenuItemType) {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
        switch type {
        case .restoreSubscriptions:
            subscriptionViewController.restoreSubscriptionFromOutside()
        case .subscriptionHistory:
            subscriptionViewController.presentSubscriptionHistoryFromOutside()
        case .usePromoCode:
            subscriptionViewController.usePromoCodeFromOutside()
        default:
            break
        }
    }
    
    private func presentWebSheet(type: MenuItemType) {
        let urlString = type.getURLString()
        let webVC = WebViewController.getInstance(with: urlString)
        self.present(webVC, animated: true, completion: nil)
    }
    
    private func presentShareSheet() {
        let appLogo = UIImage(named: "top-logo-green")!
        let appLink = Constants.appWebPageURLString
        let customMessage = "Check out \(Constants.appVisibleName)! I've been using it and it's been great. \(appLink)"
        
        let activityViewController = UIActivityViewController(activityItems: [customMessage, appLogo], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func presentRateUs() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
}
