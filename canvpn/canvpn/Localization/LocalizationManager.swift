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
    case es
    case fr
    case de
    case zh // chinese
    case fa // persian
    case ur // urdu
    case ru // russian
    case hi // hindi
    
}

class Dictionaries {
    
    /* subs_terms_detail_key
     
     We offer monthly, 3-month, 6-month, 1-year and lifetime subscriptions giving discounts to the monthly price. Prices are clearly displayed in the app.

     - Payment will be charged to your iTunes account at confirmation of purchase.

     - Your subscription will automatically renew itself unless auto-renewal is turned off at least 24 hours before the end of the current period.

     - Your account will be charged for renewal within 24 hours prior to the end of the current period.

     - You can manage your subscriptions and turn off auto-renewal by going to your Account Settings in the iTunes
     store.

     - If offered, if you choose to use our free trial, any unused portion of the free trial period will be forfeited when you purchase a subscription to that publication, where applicable.

     - If you don't choose to purchase Cleanup Pro, you can simply continue using and enjoying Cleaner Pro for free.

     Your personal data is securely stored on Cleaner Pro, be sure to read our Privacy Policy and Terms of Use.
     
     */
    
    public func getDictionary(language: LanguageEnum) -> [String : String] {
        switch language {
        case .tr:
            return TurkishDictionary.values
        case .eng:
            return EnglishDictionary.values
        case .ar:
            return ArabicDictionary.values
        case .es:
            return SpanishDictionary.values
        case .fr:
            return FrenchDictionary.values
        case .de:
            return GermanDictionary.values
        case .fa:
            return PersianDictionary.values
        case .ur:
            return UrduDictionary.values
        case .hi:
            return HindiDictionary.values
        case .ru:
            return RussianDictionary.values
        case .zh:
            return ChineseDictionary.values
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
        } else if languageCode == "es" {
            return .es
        } else if languageCode == "fr" {
            return .fr
        } else if languageCode == "zh-Hans" || languageCode == "zh-Hant" || languageCode == "zh-HK" {
            return .zh
        } else if languageCode == "fa" {
            return .fa
        } else if languageCode == "ur" {
            return .ur
        } else if languageCode == "ru" {
            return .ru
        } else if languageCode == "hi" {
            return .hi
        } else if languageCode == "de" {
            return .de
        } else {
            return .eng
        }
        
    }
    
    static func localize(key: String) -> String {
        return getStringForLanguage(key: key, lang: getUserLanguage())
        
    }
    
    static func getStringForLanguage(key: String, lang: LanguageEnum) -> String {
        return Dictionaries().getDictionary(language: lang)[key] ?? key
    }
    
}

extension String {
    func localize() -> String {
        return LocalizationManager.localize(key: self)
    }
    
}
