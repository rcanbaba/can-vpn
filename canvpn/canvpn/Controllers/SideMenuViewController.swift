//
//  SideMenuViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    private let menuItems: [(icon: UIImage?, title: String)] = [
        (icon: UIImage(named: "accountIcon"), title: "Account Information"),
        (icon: UIImage(named: "feedbackIcon"), title: "Feedback"),
        (icon: UIImage(named: "feedbackIcon"), title: "F.A.Q"),
        (icon: UIImage(named: "feedbackIcon"), title: "About Us"),
        (icon: UIImage(named: "feedbackIcon"), title: "Share Us"),
        (icon: UIImage(named: "systemIcon"), title: "Restore Subscriptions"),
        (icon: UIImage(named: "aboutIcon"), title: "Subscription History"),
        (icon: UIImage(named: "aboutIcon"), title: "Use Promo Code"),
        (icon: UIImage(named: "sharingIcon"), title: "Rate Us"),
        (icon: UIImage(named: "purchaseIcon"), title: "Check Secure"),
        (icon: UIImage(named: "purchaseIcon"), title: "What is my ip"),
        (icon: UIImage(named: "purchaseIcon"), title: "What is my speed"),
        (icon: UIImage(named: "purchaseIcon"), title: "Settings"),
        (icon: UIImage(named: "purchaseIcon"), title: ""),
        (icon: UIImage(named: "purchaseIcon"), title: ""),
        (icon: UIImage(named: "purchaseIcon"), title: ""),
        (icon: UIImage(named: "purchaseIcon"), title: "Version 1.0.1"),
        (icon: UIImage(named: "purchaseIcon"), title: "Stay secure with Love")
        
        // Add more items here
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
        cell.imageView?.image = menuItem.icon
        cell.textLabel?.text = menuItem.title
        cell.textLabel?.textColor = UIColor.Custom.goPreGrayText
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row].title
        switch selectedItem {
        case "Feedback":
//            let feedbackVC = YourFeedbackViewController() // Replace with your ViewController
//            self.presentingViewController?.present(feedbackVC, animated: true, completion: nil)
            break
        case "Share Us":
            // Present Share Menu
            let webVC = WebViewController.getInstance(with: "https://ilovevpn.app/faqs/")
                self.present(webVC, animated: true, completion: nil)
            break
        // Handle other cases here
        default:
            break
        }
    }
    
}
