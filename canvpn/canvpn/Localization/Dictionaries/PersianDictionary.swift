//
//  PersianDictionary.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.08.2023.
//

import Foundation

// fa
struct PersianDictionary {
    static let values: [String: String] = [
        "connect_key": "اتصال",
        "connecting_key": "در حال اتصال",
        "connected_key": "متصل",
        "disconnect_key": "قطع اتصال",
        "disconnected_key": "قطع شده",
        "disconnecting_key": "در حال قطع اتصال",
        "initial_key": "برای شروع کلیک کنید",
        "privacy_policy_key": "سیاست حفظ حریم خصوصی",
        "terms_of_service_key": "شرایط استفاده",
        "pp_tos_key": "با استفاده از اپلیکیشن، شما موافقت خود را با شرایط استفاده و سیاست حفظ حریم خصوصی اعلام می‌کنید.",
        "current_ip_key": "IP فعلی",
        "error_occur_reload": "خطا رخ داده است، لطفاً اپلیکیشن را مجدداً بارگیری کنید.",
        "error_occur_location": "خطا رخ داده است، لطفاً قبل از ادامه یک مکان را انتخاب کنید.",
        "error_try_again": "خطایی رخ داده است، لطفاً مجدداً تلاش کنید.",
        "error_location_again": "خطایی رخ داده است، لطفاً مکان را مجدداً انتخاب کنید!",
        "choose_location": "انتخاب مکان",
        "premium_desc_1": "مخفی کردن IP خود با مرور ناشناس",
        "premium_desc_2": "پهنای باند تا 1000 مگابایت بر ثانیه برای کاوش",
        "premium_desc_3": "از بین 10+ مکان آزادانه انتخاب کنید.",
        "premium_desc_4": "انتقال ترافیک از طریق تونل رمزنگاری شده",
        "premium_title_1": "ناشناس",
        "premium_title_2": "سریع",
        "premium_title_3": "10+ مکان",
        "premium_title_4": "امن",
        "upgrade_pro": "ارتقا به نسخه PRO",
        "upgrade_pro_detail": "آزمایش رایگان نسخه پرمیوم، هر زمان قابل لغو است.",
        "upgrade_pro_detail-re": "آزمایش رایگان نسخه پرمیوم، هر زمان قابل لغو است.",
        "premium_feature_title": "امکانات پرمیوم",
        "error_on_restore_title": "عدم توانایی در بازیابی اشتراک.",
        "error_on_restore_desc": "شما اشتراک فعالی ندارید.",
        "ok_button_key": "تایید",
        "error_on_productId": "شناسه محصول اشتراک پیدا نشد.",
        "error_on_product": "محصول اشتراک پیدا نشد.",
        "error_on_product_request": "در حال حاضر امکان دریافت محصولات اشتراک در دسترس وجود ندارد.",
        "error_on_payment": "فرایند اشتراک لغو شد.",
        "subscribe_button_key": "اکنون عضو شوید",
        "subs_terms_key": "شرایط اشتراک",
        "subs_restore_key": "بازیابی اشتراک",
        "subs_terms_detail_key" : "ما اشتراک‌های هفتگی، ماهانه، سالانه و مادام‌العمر را با تخفیف بر روی قیمت ماهانه ارائه می‌دهیم. قیمت‌ها در برنامه به وضوح نمایش داده می‌شود.\n- پرداخت از حساب iTunes شما هنگام تأیید خرید کسر خواهد شد.\n- اشتراک شما به طور خودکار تجدید خواهد شد مگر اینکه تجدید خودکار حداقل 24 ساعت قبل از پایان دوره جاری خاموش باشد.\n- حساب شما برای تجدید در 24 ساعت قبل از پایان دوره جاری شارژ خواهد شد.\n- شما می‌توانید اشتراک‌های خود را مدیریت کرده و تجدید خودکار را با رفتن به تنظیمات حساب در فروشگاه iTunes خاموش کنید.\n- اگر ارائه شود و شما تصمیم بگیرید از آزمایشی رایگان ما استفاده کنید، هر بخش استفاده نشده از دوره آزمایشی رایگان زمانی که شما اشتراکی برای این انتشار خریداری کنید از دست خواهد رفت، جایی که قابل اجرا باشد.\n- اگر شما تصمیم به خرید iLove VPN نگیرید، می‌توانید به",
        "upgraded_to_pro": "کاربر پریمیوم",
        "upgraded_to_pro_detail": "شما می‌توانید تمام مکان‌ها را به عنوان پریمیوم استفاده کنید.",
        "free_user_selected_premium_message": "برای استفاده از مکان پریمیوم باید مشترک شوید.",
        "try_coupon_code_key": "کد تخفیف را امتحان کنید",
        "enter_coupon_code": "کد تخفیف را وارد کنید",
        "coupon_code_placeholder": "کد تخفیف",
        "coupon_alert_cancel": "لغو",
        "coupon_alert_try": "امتحان کنید",
        "best_tag": "بهترین پیشنهاد",
        "discount_tag": "تخفیف",
        "unknown_product_title": "محصول ناشناخته",
        "congrats_title": "تبریک می‌گوییم!",
        "get_free_popup_description": "شما فرصت برنده شدن به یک عضویت پریمیوم یک ماهه با حساب کاربری خودتان از طریق یک کد تبلیغاتی اختصاصی را بدست آورده‌اید. \nفقط آدرس ایمیل خود را وارد کنید و می‌توانید از مزایای دسترسی پریمیوم استفاده کنید.",
        "get_free_popup_email_placeholder": "آدرس ایمیل خود را وارد کنید",
        "get_free_popup_get_code": "گرفتن کد",
        "get_free_popup_empty_email_error": "آدرس ایمیل نمی‌تواند خالی باشد.",
        "ERROR_TIMEOUT" : "درخواست به سرور به پایان رسیده است. لطفاً دوباره تلاش کنید.",
        "ERROR_INVALID_ENDPOINT" : "یک خطای داخلی سرور در حین پردازش درخواست رخ داده است. لطفاً دوباره تلاش کنید.",
        "ERROR_SERVER_ERROR" : "یک خطای داخلی سرور در حین پردازش درخواست رخ داده است.",
        "ERROR_COUPON_NOT_FOUND" : "کد کوپن درخواست شده یافت نشد.",
        "ERROR_COUPON_EXPIRED" : "کد کوپن منقضی شده است و دیگر معتبر نیست.",
        "ERROR_UNKNOWN" : "یک خطای ناشناخته رخ داده است. لطفاً دوباره تلاش کنید.",
        "ERROR_EMAIL_INVALID": "آدرس ایمیل ارائه شده معتبر نمی‌باشد.",
        "coupon_generate_success": "کوپن به آدرس ایمیل شما ارسال شده است!",
        "FAQ_contactUs_key": "نیاز به کمک دارید؟ به سوالات متداول مراجعه کنید یا از طریق تماس با ما با ما در ارتباط باشید.",
        "FAQ_key": "سوالات متداول",
        "contactUs_key": "تماس با ما",
        "subs_history_title": "تاریخچه اشتراک",
        "subs_history_empty": "هیچ اشتراکی وجود ندارد!",
        
        "account_side_title": "حساب",
        "restore_subs_side_title": "بازیابی اشتراک",
        "subs_history_side_title": "تاریخچه اشتراک",
        "promo_code_side_title": "استفاده از کد تبلیغاتی",
        "share_side_title": "ما را به اشتراک بگذارید",
        "rate_side_title": "ما را ارزیابی کنید",
        "about_side_title": "درباره ما",
        "faq_side_title": "پرسش‌های متداول",
        "feedback_side_title": "بازخورد",
        "security_side_title": "بررسی امنیت",
        "ip_side_title": "آی‌پی من چیست؟",
        "speed_side_title": "سرعت اینترنت من چیست؟",
        "settings_side_title": "تنظیمات",
        "version_side_title": "نسخه",
        "motto_side_title": "با عشق امنیتی داشته باشید",
        
        "terms_of_service": "شرایط خدمات",
        "privacy_policy": "سیاست حریم خصوصی",
        "premium_key": "پریمیوم",
        "free_key": "رایگان",
        "acc_subs_key": "اشتراک حساب",
        "acc_creation_date_key": "تاریخ ایجاد حساب",
        "device_model_key": "مدل دستگاه",
        "original_ip_address": "آدرس آی‌پی اصلی",
        "language_settings_key": "تنظیمات زبان",
        
        "display_turkish": "ترکی",
        "display_english": "انگلیسی",
        "display_arabic": "عربی",
        "display_spanish": "اسپانیایی",
        "display_french": "فرانسوی",
        "display_german": "آلمانی",
        "display_portuguese": "پرتغالی",
        "display_indonesian": "اندونزیایی",
        "display_persian": "فارسی",
        "display_urdu": "اردو",
        "display_hindi": "هندی",
        "display_russian": "روسی",
        "display_chinese": "چینی",
        "display_ukrainian": "اوکراینی",

        "checking_key": "در حال بررسی...",
        "network_secure_key": "شبکه شما ایمن است!",
        "network_not_secure_key": "شبکه شما تهدید می‌شود!",
        
        "sec_ip_address": "آدرس آی‌پی شما",
        "sec_tracked": "فعالیت‌های شبکه‌ای ممکن است دنبال شود",
        "sec_encrypted": "تونل رمزنگاری نشده",
        "sec_hacker": "حملات هکر",
        "not_sec_ip_address": "آدرس آی‌پی شما: مخفی شده",
        "not_sec_tracked": "شبکه نمی‌تواند دنبال شود",
        "not_sec_encrypted": "تونل رمزنگاری شده",
        "not_sec_hacker": "حملات هکر مسدود شده",

        "loc_header_premium": "پریمیوم",
        "loc_header_free": "رایگان",
        "loc_header_stream": "استریم",
        "loc_header_game": "گیم",
        
        // subscription
        "1 Month Plan": "طرح 1 ماهه",
        "6 Month Plan": "طرح 6 ماهه",
        "1 Year Plan": "طرح 1 ساله",
        "1 Month VIP Plan": "طرح VIP 1 ماهه",
        "1 Month Introductory Plan": "طرح معرفی 1 ماهه رایگان",
        
        "Unlimited Access for 1 Month": "دسترسی نامحدود برای 1 ماه",
        "Unlimited Access for 6 Months": "دسترسی نامحدود برای 6 ماه",
        "Unlimited Access for 1 Year": "دسترسی نامحدود برای 1 سال",
        "VIP Access for 1 Month": "دسترسی VIP با 60% تخفیف",
        "Unlimited Access for 1 Month Introductory": "دسترسی نامحدود برای 1 ماه رایگان",
        
        "subs_page_title": "پلن PREMIUM I LOVE VPN را بگیرید",
        "subs_overlay_choose": "پلن مورد نظر خود را انتخاب کنید",
        
        // rating
        "rating_title": "نظر شما در مورد iLove VPN ما را بهبود می‌بخشد!",
        "rating_description": "لطفاً به ما امتیاز دهید و نظرات خود را به اشتراک بگذارید! نظرات شما به ما کمک می‌کند تا رشد کنیم و بهتر شویم.\nاز حمایت شما سپاسگزاریم!",
        "rating_thank_you": "از نظرات شما سپاسگزاریم!",
        "rating_1star": "وحشتناک!",
        "rating_2star": "آها؟!",
        "rating_3star": "خوب!",
        "rating_4star": "عالی!",
        "rating_5star": "عالی!",
        "rating_cancel": "لغو",
        "rating_rate": "امتیاز دهید",
        
        // landing
        "landing_1_title": "حریم خصوصی بدون محدودیت",
        "landing_1_description": "حفاظت از حضور آنلاین خود با iLove VPN.\nحریم خصوصی در دستان شما.",
        "landing_1_button": "ادامه",
        
        "landing_2_title": "دسترسی جهانی، سرعت محلی",
        "landing_2_description": "با سرعت بالا از بیش از ۱۰۰ مکان، دنیایی از محتوا را باز کنید.",
        "landing_2_button": "ادامه",
        
        "support_us_landing": "آیا از رشد ما با دادن یک امتیاز حمایت می‌کنید؟",

        "landing_3_title": "دروازه‌ای به سوی آزادی",
        "landing_3_description": "سفر خود را به سمت اینترنت بدون وقفه آغاز کنید.",
        "landing_3_button": "شروع کنید",
        
        "premium_desc_5": "بدون تبلیغات مرور کنید تا تجربه‌ای بی‌وقفه داشته باشید.",
        "premium_title_5": "بدون تبلیغات",
        
        // special offer
        "landing_offer_title": "گارانتی بازگشت وجه 30 روزه",
        "landing_offer_description": "از ویژگی‌های پریمیوم خود با گارانتی بازگشت وجه 100٪ لذت ببرید",
        "landing_offer_button": "این را رایگان امتحان کنید",
        
        "offer_info_text_before": "3 روز رایگان امتحان کنید، سپس",
        "offer_info_text_duration": "هر هفته",
        
        "offer_alert_title": "پیشنهاد ویژه",
        "offer_alert_message": "شما در حال از دست دادن پیشنهاد ویژه خود هستید. مطمئن هستید؟",
        "offer_alert_cancel": "لغو",
        "offer_alert_try": "همین الان امتحان کنید",
        
        "special_offer_title": "پیشنهاد ویژه یکبار",
        "special_offer_discount_text": "دریافت\n75٪ تخفیف",
        "special_offer_button": "این را رایگان امتحان کنید",
        
        "speed_slow": "کند",
        "speed_average": "متوسط",
        "speed_fast": "سریع",
        "speed_super": "بسیار سریع",
        
        "secured_offer_text": "توسط اپل تأمین شده است، هر زمان که بخواهید لغو کنید!",
        "save_discount_text": "صرفه‌جویی",
        
        "connect_offer_title": "سرعت خود را افزایش دهید",
        "connect_offer_description": "شما در حال حاضر به یک اتصال کندتر هستید. به Premium ارتقا دهید تا مرورگری بسیار سریع داشته باشید",
        "connect_offer_button": "اکنون افزایش دهید",
        
        "timer_offer_title": "پیشنهاد محدود به زمان",
        "timer_offer_description": "شما در حال حاضر به یک اتصال کندتر هستید. به Premium ارتقا دهید تا مرورگری بسیار سریع داشته باشید",
        "timer_offer_button": "شروع اشتراک",
        
        "paywall_button": "شروع اشتراک",
        "paywall_promo_text": "من یک کد تبلیغاتی دارم",
        "paywall_restore": "بازگردانی",
        "paywall_item_1_title": "سرعت‌های فوق‌العاده",
        "paywall_item_1_description": "از مرور و پخش بدون وقفه با سرورهای با سرعت بالا لذت ببرید.",
        "paywall_item_2_title": "امنیت سطح بالا",
        "paywall_item_2_description": "داده‌های خود را با رمزگذاری پیشرفته و پروتکل‌های امنیتی برتر محافظت کنید.",
        "paywall_item_3_title": "ناشناس بودن کامل",
        "paywall_item_3_description": "با حفظ هویت خود از نگاه‌های کنجکاو، به صورت کاملاً خصوصی در وب گشت و گذار کنید.",
        "paywall_item_4_title": "بیش از 50 مکان در سراسر جهان",
        "paywall_item_4_description": "برای تجربه‌ای واقعی جهانی در فضای آنلاین به سرورهایی در بیش از 10 کشور دسترسی پیدا کنید.",
        
        "Monthly Plan": "طرح ماهانه",
        "Weekly Plan": "طرح هفتگی"
    ]
}

