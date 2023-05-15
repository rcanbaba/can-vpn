//
//  LocationViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.03.2023.
//

import UIKit

protocol LocationViewControllerDelegate: AnyObject {
    func selectedServer(server: Server)
}

class LocationViewController: UIViewController {
    
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
    
    private var serverList: [Server] = []
    
    init(serverList:  [Server]) {
        self.serverList = serverList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as! LocationListTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let cellData = serverList[indexPath.row]
        cell.set(country: cellData.location.city)
        cell.set(flagImageCountryCode: cellData.location.countryCode.lowercased())
        
        if indexPath.row < 4 {
            cell.set(signalImage: SignalLevel.perfect.getSignalImage())
            cell.set(isPremium: true)
        } else if indexPath.row < 9 {
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: true)
        } else if indexPath.row < 14 {
            cell.set(signalImage: SignalLevel.good.getSignalImage())
            cell.set(isPremium: false)
        } else {
            cell.set(signalImage: SignalLevel.medium.getSignalImage())
            cell.set(isPremium: false)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.selectedServer(server: serverList[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}