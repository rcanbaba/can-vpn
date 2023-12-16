//
//  LocationViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.03.2023.
//

import UIKit
import FirebaseAnalytics

protocol LocationViewControllerDelegate: AnyObject {
    func selectedServer(server: Server)
}

class LocationViewController: UIViewController {
    
    struct Section {
        var name: String
        var items: [Server]
        var isExpanded: Bool
    }
    
    weak var delegate: LocationViewControllerDelegate?
    
    private lazy var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LocationListTableViewCell.self, forCellReuseIdentifier: "LocationListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(onRefreshControl(_:)), for: .valueChanged)
//        tableView.refreshControl = refreshControl

        return tableView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-gray")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var serverData: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("201-PresentLocationScreen", parameters: ["type" : "didload"])
        let serverList = SettingsManager.shared.settings?.servers ?? []
        
        let premiumServers = serverList.filter { $0.type.isPremium()}
        let freeServers = serverList.filter { !$0.type.isPremium()}
        let gamingServers = serverList.filter { $0.categories.contains(3)}
        let streamingServers = serverList.filter { $0.categories.contains(4)}
        serverData = [
            Section(name: "loc_header_premium".localize(), items: premiumServers, isExpanded: true),
            Section(name: "loc_header_free".localize(), items: freeServers, isExpanded: true),
            Section(name: "loc_header_game".localize(), items: gamingServers, isExpanded: false),
            Section(name: "loc_header_stream".localize(), items: streamingServers, isExpanded: false),
        ]
        
        view.backgroundColor = UIColor.white
        configureUI()
        locationTableView.reloadData()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
    }
    
    private func setNavigationBar() {
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = "choose_location".localize()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        navigationItem.titleView = headerView
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func presentSubscriptionPage() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return serverData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverData[section].isExpanded ? serverData[section].items.count : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return serverData[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = serverData[section].name
        titleLabel.textColor = UIColor.Custom.dark
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(16)
            make.centerY.equalTo(headerView)
        }
        
        // Set up the arrow image view
        let arrowImageView = UIImageView(image:  UIImage(systemName: "location.circle.fill")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal))
        if serverData[section].isExpanded {
            arrowImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        headerView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalTo(headerView).offset(-16)
            make.centerY.equalTo(headerView)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        // Add tap gesture to the headerView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSection(_:)))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as! LocationListTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        let cellData = serverData[indexPath.section].items[indexPath.row]
        cell.set(country: cellData.location.city)
        cell.set(flagImageCountryCode: cellData.location.countryCode.lowercased())
        cell.set(signalImage: SignalLevel(rawValue: cellData.ping)?.getSignalImage())
        cell.set(isPremium: cellData.type.isPremium())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedServer = serverData[indexPath.section].items[indexPath.row]
    
        if selectedServer.type.isPremium() && SettingsManager.shared.settings?.user.isSubscribed == false {
            presentSubscriptionPage()
            Toaster.showToast(message: "free_user_selected_premium_message".localize())
            return
        } else {
            navigationController?.popViewController(animated: true)
            delegate?.selectedServer(server: selectedServer)
        }
    }
    
    @objc func toggleSection(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view  else { return}
        
        let section = headerView.tag
        let numberOfRows = serverData[section].items.count
        var indexPaths = [IndexPath]()
        
        for row in 0..<numberOfRows {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        
        serverData[section].isExpanded.toggle()
        
        if let arrowImageView = headerView.subviews.compactMap({ $0 as? UIImageView }).first {
            UIView.animate(withDuration: 0.3) {
                if self.serverData[section].isExpanded {
                    arrowImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
                } else {
                    arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
        }
        
        locationTableView.beginUpdates()
        if serverData[section].isExpanded {
            locationTableView.insertRows(at: indexPaths, with: .fade)
        } else {
            locationTableView.deleteRows(at: indexPaths, with: .fade)
        }
        locationTableView.endUpdates()
    }
    
}
