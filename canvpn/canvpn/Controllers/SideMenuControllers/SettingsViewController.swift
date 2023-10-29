//
//  SettingsViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    let languages = ["Turkish", "English", "Arabic", "Spanish", "French", "German", "Portuguese", "Indonesian", "Persian", "Urdu", "Hindi", "Russian", "Chinese"]
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Language Settings"
        label.textColor = UIColor.Custom.goPreGrayText
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.95)
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(mainLabel)
        view.addSubview(tableView)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.Custom.goPreGrayText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected language: \(languages[indexPath.row])")
        // Implement further actions here...
    }

}
