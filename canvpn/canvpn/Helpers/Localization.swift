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
        "connect_key" : "Bağlan",
        "connecting_key": "Bağlanıyor",
        "connected_key": "Bağlandı",
        "disconnect_key" : "Bağlantıyı kes",
        "disconnected_key": "Bağlantı kesildi",
        "disconnecting_key": "Bağlantı kesiliyor",
        "initial_key": "Başlamak için dokun",
        "privacy_policy_key": "Gizlilik Politikasını",
        "terms_of_service_key": "Kullanım Şartları",
        "pp_tos_key": "Uygulamayı kullanarak Kullanım Şartları ve Gizlilik Politikasını kabul etmiş olursunuz.",
        "current_ip_key": "IP Adresiniz",
        "error_occur_reload" : "Error occurred, please reload app.",
        "error_occur_location" : "Error occurred, please select a location before.",
        "error_try_again" : "Error occurred, please try again.",
        "error_location_again" : "Error occurred, please select location again!",
        "choose_location": "Konum Seç",
        "premium_desc_1": "Hide your ip with anonymous surfing",
        "premium_desc_2": "Up to 1000 Mb/s bandwidth to explore",
        "premium_desc_3": "Enjoy the app without annoying ads",
        "premium_desc_4": "Transfer traffic via encrypted tunnel",
        "premium_title_1": "Anonymous",
        "premium_title_2": "Fast",
        "premium_title_3": "Remove Ads",
        "premium_title_4": "Secure",
        "upgrade_pro": "Upgrade To PRO",
        "upgrade_pro_detail": "Try premium free, cancel anytime.",
        "premium_feature_title": "Premium Features"
    ]
    
    private var engDictionary = [
        "connect_key" : "Connect",
        "connecting_key": "Connecting",
        "connected_key": "Connected",
        "disconnect_key" : "Disconnect",
        "disconnected_key": "Disconnected",
        "disconnecting_key": "Disconnecting",
        "initial_key": "Tap to start",
        "privacy_policy_key": "Privacy Policy",
        "terms_of_service_key": "Terms of Use",
        "pp_tos_key": "By using the application you agree to the Terms of Use and Privacy Policy.",
        "current_ip_key": "Current IP",
        "error_occur_reload" : "Error occurred, please reload app.",
        "error_occur_location" : "Error occurred, please select a location before.",
        "error_try_again" : "Error occurred, please try again.",
        "error_location_again" : "Error occurred, please select location again!",
        "choose_location": "Choose Location",
        "premium_desc_1": "Hide your ip with anonymous surfing",
        "premium_desc_2": "Up to 1000 Mb/s bandwidth to explore",
        "premium_desc_3": "Enjoy the app without annoying ads",
        "premium_desc_4": "Transfer traffic via encrypted tunnel",
        "premium_title_1": "Anonymous",
        "premium_title_2": "Fast",
        "premium_title_3": "Remove Ads",
        "premium_title_4": "Secure",
        "upgrade_pro": "Upgrade To PRO",
        "upgrade_pro_detail": "Try premium free, cancel anytime.",
        "premium_feature_title": "Premium Features"
    ]
    
    private var arDictionary = [
        "connect_key" : "يتصل",
        "connecting_key": "توصيل",
        "connected_key": "متصل",
        "disconnect_key" : "Bağlantıyı es",
        "disconnected_key": "انقطع الاتصال",
        "disconnecting_key": "قطع الاتصال",
        "initial_key": "انقر للبدء",
        "privacy_policy_key": "سياسة الخصوصية",
        "terms_of_service_key": "شروط الاستخدام",
        "pp_tos_key": "باستخدام التطبيق ، فإنك توافق على شروط الاستخدام وسياسة الخصوصية.",
        "current_ip_key": "IP الحالي",
        "error_occur_reload" : "Error occurred, please reload app.",
        "error_occur_location" : "Error occurred, please select a location before.",
        "error_try_again" : "Error occurred, please try again.",
        "error_location_again" : "Error occurred, please select location again!",
        "choose_location": "Choose Location",
        "premium_desc_1": "Hide your ip with anonymous surfing",
        "premium_desc_2": "Up to 1000 Mb/s bandwidth to explore",
        "premium_desc_3": "Enjoy the app without annoying ads",
        "premium_desc_4": "Transfer traffic via encrypted tunnel",
        "premium_title_1": "Anonymous",
        "premium_title_2": "Fast",
        "premium_title_3": "Remove Ads",
        "premium_title_4": "Secure",
        "upgrade_pro": "Upgrade To PRO",
        "upgrade_pro_detail": "Try premium free, cancel anytime.",
        "premium_feature_title": "Premium Features"
    ]
    
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
        let languageCode = Locale.preferredLocale().languageCode?.lowercased()
        
        if languageCode == "tr" {
            return .tr
        } else if languageCode == "ar" {
            return .ar
        } else {
            return .eng
        }

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
