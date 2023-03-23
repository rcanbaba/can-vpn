//
//  LocationViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.03.2023.
//

import UIKit

class LocationViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureUI()
        locationTableView.reloadData()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = "Choose Location".localize()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        navigationItem.titleView = headerView
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    private func configureUI() {
        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as! LocationListTableViewCell
        
        
        if indexPath.row == 0 {
            cell.set(country: "Turkey")
            cell.set(flagImageCountryCode: "tr")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: true)
        }
        if indexPath.row == 1 {
            cell.set(country: "Germany")
            cell.set(flagImageCountryCode: "de")
            cell.set(signalImage: SignalLevel.perfect.getSignalImage())
            cell.set(isPremium: true)
        }
        if indexPath.row == 2 {
            cell.set(country: "USA")
            cell.set(flagImageCountryCode: "us")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        }
        if indexPath.row == 3 {
            cell.set(country: "Adana")
            cell.set(flagImageCountryCode: "tr")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        }
        if indexPath.row == 4 {
            cell.set(country: "Mersin" + "\(indexPath.row)")
            cell.set(flagImageCountryCode: "tr")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        }
        if indexPath.row == 5 {
            cell.set(country: "Azerbaycan" + "\(indexPath.row)")
            cell.set(flagImageCountryCode: "az")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        }
        if indexPath.row == 6 {
            cell.set(country: "Netherlands" + "\(indexPath.row)")
            cell.set(flagImageCountryCode: "nh")
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}
