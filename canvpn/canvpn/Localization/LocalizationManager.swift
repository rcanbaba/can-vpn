//
//  Localization.swift
//  canvpn
//
//  Created by Can Babaoğlu on 25.12.2022.
//

import Foundation

enum LanguageEnum: String, CaseIterable {
    case tr
    case eng
    case ar
    case es
    case fr
    case de
    case pt
    case id
    case zh // chinese
    case fa // persian
    case ur // urdu
    case ru // russian
    case hi // hindi
    
    var displayName: String {
        switch self {
        case .tr: return "display_turkish".localize()
        case .eng: return "display_english".localize()
        case .ar: return "display_arabic".localize()
        case .es: return "display_spanish".localize()
        case .fr: return "display_french".localize()
        case .de: return "display_german".localize()
        case .pt: return "display_portuguese".localize()
        case .id: return "display_indonesian".localize()
        case .fa: return "display_persian".localize()
        case .ur: return "display_urdu".localize()
        case .hi: return "display_hindi".localize()
        case .ru: return "display_russian".localize()
        case .zh: return "display_chinese".localize()
        }
    }
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
        case .pt:
            return PortugueseDictionary.values
        case .id:
            return IndonesianDictionary.values
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
        let languageCode = KeyValueStorage.languageCode ?? Constants.langCode
        
        if languageCode == "tr" {
            return .tr
        } else if languageCode == "ar" {
            return .ar
        } else if languageCode == "es" {
            return .es
        } else if languageCode == "fr" {
            return .fr
        } else if languageCode == "de" {
            return .de
        } else if languageCode == "pt" || languageCode == "pt-BR" {
            return .pt
        } else if languageCode == "id" || languageCode == "in-ID" {
            return .id
        } else if languageCode == "zh" || languageCode == "zh-Hant" || languageCode == "zh-HK" || languageCode == "zh-Hans" {
            return .zh
        } else if languageCode == "fa" {
            return .fa
        } else if languageCode == "ur" {
            return .ur
        } else if languageCode == "ru" {
            return .ru
        } else if languageCode == "hi" {
            return .hi
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
