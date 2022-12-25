//
//  Localization.swift
//  canvpn
//
//  Created by Can Babaoğlu on 25.12.2022.
//

import Foundation

enum LanguageEnum {
    case tr
    case eng
    case ar
}

class Dictionaries {
    private var trDictionary = [
        "connect_key" : "bağlan",
        "connecting_key": "bağlanıyor",
        "connected_key": "bağlandı",
        "disconnected_key": "bağlantı kesildi",
        "disconnecting_key": "bağlantı kesiliyor",
        "initial_key": "başlamak için dokun",
        "privacy_policy_key": "Gizlilik Politikasını",
        "terms_of_service_key": "Kullanım Şartları",
        "pp_tos_key": "Uygulamayı kullanarak Kullanım Şartları ve Gizlilik Politikasını kabul etmiş olursunuz.",
        "curren_ip_key": "IP Adresiniz:"
    ]
    
    private var engDictionary = [String : String]()
    private var arDictionary = [String : String]()
    
    public func getDictionary(language: LanguageEnum) -> [String : String] {
        switch language {
        case .tr:
            return trDictionary
        case .eng:
            return engDictionary
        case .ar:
            return arDictionary
        }
    }
}


class LocalizationManager {

    static func getUserLanguage() -> LanguageEnum {
        // TODO: get device language
        return .tr
    }
    
    static func localize(key: String) -> String {
        return getStringForLanguage(key: key, lang: getUserLanguage())
        
    }
    
    
    static func getStringForLanguage(key: String, lang: LanguageEnum) -> String {
        return Dictionaries().getDictionary(language: lang)[key] ?? ""    }
    
}

extension String {
    
    func localize() -> String {
        return LocalizationManager.localize(key: self)
    }
    
}
