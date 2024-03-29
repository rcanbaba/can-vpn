//
//  SideMenuViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import StoreKit

class SideMenuViewController: UIViewController {
    
    private var menuItems: [MenuItemType] = []
    
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
        setMenuItemArray()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        addNotifications()
        configureUI()
    }
    
    private func setMenuItemArray() {
        menuItems = [
            .accountInformation, // ip adress - subs type
            .restoreSubscriptions, // yönlendir
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
        
        if SettingsManager.shared.settings?.isInReview != true {
            menuItems.insert(.usePromoCode, at: 3)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name.languageChanged, object: nil)
    }
    
    @objc func updateLanguage() {
        DispatchQueue.main.async {
            self.menuTableView.reloadData()
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
        let appLink = Constants.shareUsURLString
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
