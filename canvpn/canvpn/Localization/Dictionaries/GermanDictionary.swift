//
//  GermanDictionary.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.08.2023.
//

import Foundation

// de
struct GermanDictionary {
    static let values: [String: String] = [
        "connect_key": "Verbinden",
        "connecting_key": "Verbindung wird hergestellt",
        "connected_key": "Verbunden",
        "disconnect_key": "Trennen",
        "disconnected_key": "Getrennt",
        "disconnecting_key": "Verbindung wird getrennt",
        "initial_key": "Tippen, um zu starten",
        "privacy_policy_key": "Datenschutzrichtlinie",
        "terms_of_service_key": "Nutzungsbedingungen",
        "pp_tos_key": "Durch die Nutzung der Anwendung stimmen Sie den Nutzungsbedingungen und der Datenschutzrichtlinie zu.",
        "current_ip_key": "Aktuelle IP",
        "error_occur_reload": "Es ist ein Fehler aufgetreten, bitte App neu laden.",
        "error_occur_location": "Es ist ein Fehler aufgetreten, bitte wählen Sie zuerst einen Standort aus.",
        "error_try_again": "Es ist ein Fehler aufgetreten, bitte versuchen Sie es erneut.",
        "error_location_again": "Es ist ein Fehler aufgetreten, bitte wählen Sie den Standort erneut.",
        "choose_location": "Standort auswählen",
        "premium_desc_1": "Verbergen Sie Ihre IP mit anonymem Surfen",
        "premium_desc_2": "Bis zu 1000 Mb/s Bandbreite zum Erkunden",
        "premium_desc_3": "Wählen Sie frei aus über 10 Standorten.",
        "premium_desc_4": "Übertragen Sie den Datenverkehr über einen verschlüsselten Tunnel",
        "premium_title_1": "Anonym",
        "premium_title_2": "Schnell",
        "premium_title_3": "10+ Standort",
        "premium_title_4": "Sicher",
        "upgrade_pro": "Auf PRO upgraden",
        "upgrade_pro_detail": "Premium kostenlos ausprobieren, jederzeit kündbar.",
        "premium_feature_title": "Premium-Funktionen",
        "error_on_restore_title": "Wiederherstellung des Abonnements fehlgeschlagen.",
        "error_on_restore_desc": "Sie haben kein aktives Abonnement.",
        "ok_button_key": "Ok",
        "error_on_productId": "Abonnement-Produktkennung nicht gefunden.",
        "error_on_product": "Abonnement-Produkt nicht gefunden.",
        "error_on_product_request": "Aktuell können keine verfügbaren Abonnement-Produkte abgerufen werden.",
        "error_on_payment": "Der Abonnementvorgang wurde abgebrochen.",
        "subscribe_button_key": "JETZT ABONNIEREN",
        "subs_terms_key": "Abonnementbedingungen",
        "subs_restore_key": "Abonnement wiederherstellen",
        "subs_terms_detail_key" : "Wir bieten wöchentliche, monatliche, jährliche und lebenslange Abonnements mit Rabatten auf den monatlichen Preis an. Die Preise werden in der App deutlich angezeigt.\n- Die Zahlung wird bei Bestätigung des Kaufs von Ihrem iTunes-Konto abgebucht.\n- Ihr Abonnement wird automatisch verlängert, sofern die automatische Verlängerung nicht mindestens 24 Stunden vor Ende des aktuellen Zeitraums deaktiviert wird.\n- Ihrem Konto wird die Verlängerung innerhalb von 24 Stunden vor dem Ende des aktuellen Zeitraums berechnet.\n- Sie können Ihre Abonnements verwalten und die automatische Verlängerung in den Kontoeinstellungen im iTunes Store deaktivieren.\n- Wenn angeboten, und Sie sich entscheiden, unsere kostenlose Testversion zu nutzen, wird der ungenutzte Teil des kostenlosen Testzeitraums verfallen, wenn Sie ein Abonnement für diese Publikation kaufen, wo zutreffend.\n- Wenn Sie sich entscheiden, iLove VPN nicht zu kaufen, können Sie iLove VPN weiterhin kostenlos nutzen und genießen.\nIhre persönlichen Daten werden sicher auf iLove VPN gespeichert. Bitte lesen Sie unsere Datenschutzrichtlinie und Nutzungsbedingungen.",
        "upgraded_to_pro": "Premium-Benutzer",
        "upgraded_to_pro_detail": "Du kannst alle Standorte als Premium nutzen.",
        "free_user_selected_premium_message": "Du musst ein Abonnement abschließen, um den Premium-Standort zu nutzen.",
        "try_coupon_code_key": "Coupon-Code versuchen",
        "enter_coupon_code": "Coupon-Code eingeben",
        "coupon_code_placeholder": "Coupon-Code",
        "coupon_alert_cancel": "Abbrechen",
        "coupon_alert_try": "Versuchen",
        "best_tag": "Bestes Angebot",
        "discount_tag": "Rabatt",
        "unknown_product_title": "Unbekanntes Produkt",
        "congrats_title": "Herzlichen Glückwunsch!",
        "get_free_popup_description": "Sie haben die Chance gewonnen, eine exklusive Einladung für eine einmonatige Premium-Mitgliedschaft mit Ihrem Konto über einen exklusiven Promo-Code zu erhalten. \nGeben Sie einfach Ihre E-Mail-Adresse ein, und Sie können die Vorteile des Premium-Zugangs genießen.",
        "get_free_popup_email_placeholder": "Geben Sie Ihre E-Mail-Adresse ein",
        "get_free_popup_get_code": "Code erhalten",
        "get_free_popup_empty_email_error": "Die E-Mail-Adresse darf nicht leer sein.",
        "ERROR_TIMEOUT" : "Die Anfrage an den Server hat das Zeitlimit überschritten. Bitte versuchen Sie es erneut.",
        "ERROR_INVALID_ENDPOINT" : "Bei der Verarbeitung der Anfrage ist ein interner Serverfehler aufgetreten. Bitte versuchen Sie es erneut.",
        "ERROR_SERVER_ERROR" : "Bei der Verarbeitung der Anfrage ist ein interner Serverfehler aufgetreten.",
        "ERROR_COUPON_NOT_FOUND" : "Der angeforderte Gutscheincode konnte nicht gefunden werden.",
        "ERROR_COUPON_EXPIRED" : "Der Gutscheincode ist abgelaufen und ungültig geworden.",
        "ERROR_UNKNOWN" : "Ein unbekannter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.",
        "ERROR_EMAIL_INVALID": "Die angegebene E-Mail-Adresse ist ungültig.",
        "coupon_generate_success": "Der Gutschein wurde an Ihre E-Mail-Adresse gesendet!",
        "FAQ_contactUs_key": "Brauchen Sie Hilfe? Besuchen Sie Häufig Gestellte Fragen oder kontaktieren Sie uns über Kontaktieren Sie Uns.",
        "FAQ_key": "Häufig Gestellte Fragen",
        "contactUs_key": "Kontaktieren Sie Uns",
        "subs_history_title": "Abonnementverlauf",
        "subs_history_empty": "Es gibt kein Abonnement!",
        
        "account_side_title": "Konto",
        "restore_subs_side_title": "Abonnement wiederherstellen",
        "subs_history_side_title": "Abonnementverlauf",
        "promo_code_side_title": "Promo-Code verwenden",
        "share_side_title": "Teilen Sie uns mit",
        "rate_side_title": "Bewerten Sie uns",
        "about_side_title": "Über uns",
        "faq_side_title": "FAQ",
        "feedback_side_title": "Feedback",
        "security_side_title": "Sicherheit überprüfen",
        "ip_side_title": "Was ist meine IP?",
        "speed_side_title": "Was ist meine Geschwindigkeit?",
        "settings_side_title": "Einstellungen",
        "version_side_title": "Version",
        "motto_side_title": "Bleiben Sie sicher mit Liebe",
        
        "terms_of_service": "Nutzungsbedingungen",
        "privacy_policy": "Datenschutzrichtlinie",
        "premium_key": "Premium",
        "free_key": "Kostenlos",
        "acc_subs_key": "Kontoabonnement",
        "acc_creation_date_key": "Kontenerstellungsdatum",
        "device_model_key": "Gerätemodell",
        "original_ip_address": "Ursprüngliche IP-Adresse",
        "language_settings_key": "Spracheinstellungen",
        
        "display_turkish": "Türkisch",
        "display_english": "Englisch",
        "display_arabic": "Arabisch",
        "display_spanish": "Spanisch",
        "display_french": "Französisch",
        "display_german": "Deutsch",
        "display_portuguese": "Portugiesisch",
        "display_indonesian": "Indonesisch",
        "display_persian": "Persisch",
        "display_urdu": "Urdu",
        "display_hindi": "Hindi",
        "display_russian": "Russisch",
        "display_chinese": "Chinesisch",

        "checking_key": "Überprüfung läuft...",
        "network_secure_key": "Ihr Netzwerk ist sicher!",
        "network_not_secure_key": "Ihr Netzwerk ist gefährdet!",
        
        "sec_ip_address": "Ihre IP-Adresse",
        "sec_tracked": "Netzwerkaktivitäten können verfolgt werden",
        "sec_encrypted": "Nicht verschlüsselter Tunnel",
        "sec_hacker": "Hackerangriffe",
        "not_sec_ip_address": "Ihre IP-Adresse: Versteckt",
        "not_sec_tracked": "Das Netzwerk kann nicht verfolgt werden",
        "not_sec_encrypted": "Verschlüsselter Tunnel",
        "not_sec_hacker": "Hackerangriffe blockiert",

        "loc_header_premium": "Premium",
        "loc_header_free": "Kostenlos",
        "loc_header_stream": "Streaming",
        "loc_header_game": "Gaming",
        
        // subs
        "1 Month Plan": "1-Monats-Plan",
        "6 Month Plan": "6-Monats-Plan",
        "1 Year Plan": "1-Jahres-Plan",
        "1 Month VIP Plan": "1-Monats-VIP-Plan",
        
        "Unlimited Access for 1 Month": "Unbegrenzter Zugang für 1 Monat",
        "Unlimited Access for 6 Months": "Unbegrenzter Zugang für 6 Monate",
        "Unlimited Access for 1 Year": "Unbegrenzter Zugang für 1 Jahr",
        "VIP Access for 1 Month": "VIP-Zugang für 1 Monat"
    ]
}

