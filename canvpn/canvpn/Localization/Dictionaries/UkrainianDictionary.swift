//
//  UkrainianDictionary.swift
//  canvpn
//
//  Created by Can Babaoğlu on 17.02.2024.
//

import Foundation

struct UkrainianDictionary {
    static let values: [String: String] = [
        "connect_key": "Підключитися",
        "connecting_key": "Підключення",
        "connected_key": "Підключено",
        "disconnect_key": "Відключити",
        "disconnected_key": "Відключено",
        "disconnecting_key": "Відключення",
        "initial_key": "Торкніться, щоб розпочати",
        "privacy_policy_key": "Політика конфіденційності",
        "terms_of_service_key": "Умови користування",
        "pp_tos_key": "Використовуючи додаток, ви погоджуєтеся з Умовами користування та Політикою конфіденційності.",
        "current_ip_key": "Поточний IP",
        "error_occur_reload": "Сталася помилка, будь ласка, перезавантажте додаток.",
        "error_occur_location": "Сталася помилка, будь ласка, виберіть локацію перед цим.",
        "error_try_again": "Сталася помилка, будь ласка, спробуйте ще раз.",
        "error_location_again": "Сталася помилка, будь ласка, виберіть локацію знову!",
        "choose_location": "Вибрати локацію",
        "premium_desc_1": "Сховайте ваш IP за допомогою анонімного серфінгу.",
        "premium_desc_2": "До 1000 Мб/с пропускної спроможності для дослідження",
        "premium_desc_3": "Вільний вибір з 10+ локацій.",
        "premium_desc_4": "Передача трафіку через зашифрований тунель.",
        "premium_title_1": "Анонімність",
        "premium_title_2": "Швидкість",
        "premium_title_3": "10+ Локацій",
        "premium_title_4": "Безпека",
        "upgrade_pro": "Оновити до PRO",
        "upgrade_pro_detail": "Спробуйте преміум безкоштовно, скасуйте в будь-який час.",
        "premium_feature_title": "Преміум Функції",
        "error_on_restore_title": "Не вдалося відновити підписку.",
        "error_on_restore_desc": "У вас немає активної підписки.",
        "ok_button_key": "Гаразд",
        "error_on_productId": "Ідентифікатор продукту підписки не знайдено.",
        "error_on_product": "Продукт підписки не знайдено.",
        "error_on_product_request": "На даний момент неможливо отримати доступні продукти підписки.",
        "error_on_payment": "Процес підписки було скасовано.",
        "subscribe_button_key": "ПІДПИСАТИСЯ ЗАРАЗ",
        "subs_terms_key": "Умови підписки",
        "subs_restore_key": "Відновити підписку",
        "subs_terms_detail_key": "Ми пропонуємо три основні терміни підписки з можливістю отримання знижок за допомогою доступного промокоду. Ціни та пропозиції наступні:\n\nСтандартні тарифи підписки:\n    - 1 місяць: 11,99€\n    - 6 місяців: 59,90€ (9.99€/місяць)\n    - 12 місяців: 95,90€ (7.99€/місяць)\n\nЦіни чітко вказані в додатку.\n- Платіж буде списано з вашого облікового запису iTunes після підтвердження покупки.\n- Ваша підписка буде автоматично продовжена, якщо автопоновлення не буде вимкнено принаймні за 24 години до кінця поточного періоду.\n- Ваш обліковий запис буде зараховано за поновлення за 24 години до кінця поточного періоду.\n- Керуйте своїми підписками та вимикайте автопоновлення, перейшовши до налаштувань облікового запису в магазині iTunes.\n- Якщо пропонується, будь-яка не використана частина безкоштовного пробного періоду буде анульована при купівлі підписки.\n- Якщо ви не вирішите купити iLove VPN, ви можете продовжувати використовувати його безкоштовно.\nВаші особисті дані надійно зберігаються на iLove VPN. Будь ласка, прочитайте нашу Політику конфіденційності та Умови користування для отримання додаткової інформації.",
        "upgraded_to_pro": "Преміум користувач",
        "upgraded_to_pro_detail": "Ви можете використовувати всі локації як преміум.",
        "free_user_selected_premium_message": "Вам потрібно підписатися, щоб використовувати преміум локацію",
        "try_coupon_code_key": "Спробуйте промокод",
        "enter_coupon_code": "Введіть промокод",
        "coupon_code_placeholder": "Промокод",
        "coupon_alert_cancel": "Скасувати",
        "coupon_alert_try": "Спробувати",
        "best_tag": "Найкраща пропозиція",
        "discount_tag": "Знижка",
        "unknown_product_title": "Невідомий продукт",
        "congrats_title": "Вітаємо!",
        "get_free_popup_description": "Ви виграли можливість отримати одномісячне преміум членство за ексклюзивним промокодом. Просто надайте свою електронну пошту, і ви зможете почати користуватися перевагами преміум доступу.",
        "get_free_popup_email_placeholder": "Введіть вашу електронну пошту",
        "get_free_popup_get_code": "Отримати код",
        "get_free_popup_empty_email_error": "Електронна пошта не може бути порожньою!",
        "ERROR_TIMEOUT": "Запит до сервера перевищив час очікування. Будь ласка, спробуйте ще раз.",
        "ERROR_INVALID_ENDPOINT": "Під час обробки запиту сталася внутрішня помилка сервера. Будь ласка, спробуйте ще раз.",
        "ERROR_SERVER_ERROR": "Під час обробки запиту сталася внутрішня помилка сервера.",
        "ERROR_COUPON_NOT_FOUND": "Запитаний промокод не знайдено.",
        "ERROR_COUPON_EXPIRED": "Термін дії промокоду закінчився і він більше не дійсний.",
        "ERROR_UNKNOWN": "Сталася невідома помилка. Будь ласка, спробуйте ще раз.",
        "ERROR_EMAIL_INVALID": "Надана електронна адреса не є дійсною.",
        "coupon_generate_success": "Купон відправлено на вашу електронну адресу!",
        "FAQ_contactUs_key": "Потрібна допомога? Відвідайте розділ ЧаПи або зверніться через зв'язок з нами.",
        "FAQ_key": "ЧаПи",
        "contactUs_key": "Зв'язатися з Нами",
        
        "subs_history_title": "Історія підписок",
        "subs_history_empty": "Підписок немає!",
        
        "account_side_title": "Акаунт",
        "restore_subs_side_title": "Відновити підписку",
        "subs_history_side_title": "Історія підписок",
        "promo_code_side_title": "Використати промокод",
        "share_side_title": "Поділитися",
        "rate_side_title": "Оцініть нас",
        "about_side_title": "Про нас",
        "faq_side_title": "ЧаПи",
        "feedback_side_title": "Відгуки",
        "security_side_title": "Перевірити безпеку",
        "ip_side_title": "Який мій IP",
        "speed_side_title": "Яка моя швидкість",
        "settings_side_title": "Налаштування",
        "version_side_title": "Версія",
        "motto_side_title": "Залишайтеся в безпеці з любов'ю",
        
        "terms_of_service": "Умови обслуговування",
        "privacy_policy": "Політика конфіденційності",
        "premium_key": "Преміум",
        "free_key": "Безкоштовно",
        "acc_subs_key": "Підписка акаунта",
        "acc_creation_date_key": "Дата створення акаунта",
        "device_model_key": "Модель пристрою",
        "original_ip_address": "Оригінальна IP-адреса",
        "language_settings_key": "Налаштування мови",
        
        //Display languages
        "display_turkish": "Турецька",
        "display_english": "Англійська",
        "display_arabic": "Арабська",
        "display_spanish": "Іспанська",
        "display_french": "Французька",
        "display_german": "Німецька",
        "display_portuguese": "Португальська",
        "display_indonesian": "Індонезійська",
        "display_persian": "Перська",
        "display_urdu": "Урду",
        "display_hindi": "Хінді",
        "display_russian": "Російська",
        "display_chinese": "Китайська",
        "display_ukrainian": "Українська",
        
        "checking_key": "Перевірка...",
        "network_secure_key": "Ваша мережа в безпеці!",
        "network_not_secure_key": "Вашу мережу загрожує!",
        
        "sec_ip_address": "Ваша IP-адреса",
        "sec_tracked": "Активність у мережі може відстежуватися",
        "sec_encrypted": "Тунель не зашифровано",
        "sec_hacker": "Атаки хакерів",
        "not_sec_ip_address": "Ваша IP-адреса: Прихована",
        "not_sec_tracked": "Мережу не може бути відстежено",
        "not_sec_encrypted": "Тунель зашифровано",
        "not_sec_hacker": "Атаки хакерів заблоковано",

        "loc_header_premium": "Преміум",
        "loc_header_free": "Безкоштовно",
        "loc_header_stream": "Стрімінг",
        "loc_header_game": "Ігри",
        
        // subscription
        "1 Month Plan": "План на 1 місяць",
        "6 Month Plan": "План на 6 місяців",
        "1 Year Plan": "План на 1 рік",
        "1 Month VIP Plan": "План зі знижкою на 1 місяць",
        "1 Month Introductory Plan": "1 місяць безкоштовно, потім оплата",
        
        "Unlimited Access for 1 Month": "Необмежений доступ на 1 місяць",
        "Unlimited Access for 6 Months": "Необмежений доступ на 6 місяців",
        "Unlimited Access for 1 Year": "Необмежений доступ на 1 рік",
        "VIP Access for 1 Month": "Необмежений доступ на 1 місяць зі знижкою 60%",
        "Unlimited Access for 1 Month Introductory": "1 місяць безкоштовного необмеженого доступу",
        
        "subs_page_title": "Отримайте I LOVE VPN PREMIUM",
        "subs_overlay_choose": "Виберіть ваш план",
        
        // rating
        "rating_title": "Ми б хотіли отримати ваші відгуки про iLove VPN!",
        "rating_description": "Будь ласка, оцініть нас і поділіться своїми думками! Ваші відгуки допомагають нам рости і вдосконалюватися.\nДякуємо за вашу підтримку!",
        "rating_thank_you": "Дякуємо за ваш відгук!",
        "rating_1star": "Жахливо!",
        "rating_2star": "Ахх?!",
        "rating_3star": "Нормально!",
        "rating_4star": "Добре!",
        "rating_5star": "Відмінно!",
        "rating_cancel": "Скасувати",
        "rating_rate": "Оцінити",
        
        // landing
        "landing_1_title": "Конфіденційність без компромісів",
        "landing_1_description": "Захистіть свою онлайн присутність за допомогою iLove VPN.\nКонфіденційність у ваших руках.",
        "landing_1_button": "Продовжити",
        
        "landing_2_title": "Глобальний доступ, місцева швидкість",
        "landing_2_description": "Відкрийте для себе світ контенту на високих швидкостях з понад 100 локацій.",
        "landing_2_button": "Продовжити",
        
        "landing_3_title": "Ваші ворота до свободи",
        "landing_3_description": "Розпочніть свою подорож до більш відкритого інтернету.\nНатисніть 'Розпочати', щоб почати!",
        "landing_3_button": "Розпочати",
        
        "premium_desc_5": "Серфінг без реклами для безперебійного досвіду.",
        "premium_title_5": "Без Реклам"
    ]
}