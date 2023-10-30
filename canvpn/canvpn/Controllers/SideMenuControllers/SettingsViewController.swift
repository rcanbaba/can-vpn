//
//  SettingsViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import FirebaseAnalytics

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    let languages = [LanguageEnum.eng,
                     LanguageEnum.pt,
                     LanguageEnum.id,
                     LanguageEnum.es,
                     LanguageEnum.de,
                     LanguageEnum.fr,
                     LanguageEnum.ar,
                     LanguageEnum.ru,
                     LanguageEnum.tr,
                     LanguageEnum.zh,
                     LanguageEnum.hi,
                     LanguageEnum.fa,
                     LanguageEnum.ur]
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Language Settings"
        label.textColor = UIColor.Custom.goPreGrayText
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private var networkService: DefaultNetworkService?

    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        configureUI()
        Constants.langCode
        findSelectedLanguageIndex(language: <#T##<<error type>>#>)
    }
    
    private func findSelectedLanguageIndex(code) -> Int {
        
    }
    
    private func setSelectedLanguage() {
        
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.95)
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(mainLabel)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row].displayName
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.Custom.goPreGrayText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected language: \(languages[indexPath.row].displayName)")
        let languageCode = languages[indexPath.row].rawValue
        KeyValueStorage.languageCode = languageCode
        Constants.langCode = languageCode
        fetchSettings(languageCode: languageCode)
    }
    
    private func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.tableView.isUserInteractionEnabled = !show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    private func fetchSettings(languageCode: String) {
        guard let service = networkService else { return }
        isLoading(show: true)
        var fetchSettingsRequest = FetchSettingsRequest()
        fetchSettingsRequest.setClientParams(languageCode: languageCode)
        
        service.request(fetchSettingsRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                SettingsManager.shared.settings = response
                self.printDebug("fetchSettingsRequest - success")
                self.userEntry()
                self.isLoading(show: false)
            case .failure(_):
                self.isLoading(show: false)
                self.printDebug("fetchSettingsRequest - failure")
                Analytics.logEvent("005-API-fetchSettingsRequest", parameters: ["error" : "happened"])
            }
        }
    }
    
    private func userEntry() {
        guard let service = networkService else { return }
        var userEntryRequest = UserEntryRequest()
        userEntryRequest.setClientParams()
        
        service.request(userEntryRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ): break
            case .failure(let error):
                self.printDebug("userEntryRequest - failure")
                Analytics.logEvent("025-API-userEntryRequest", parameters: ["error" : ErrorHandler.getErrorMessage(for: error)])
            }
        }
    }

}
