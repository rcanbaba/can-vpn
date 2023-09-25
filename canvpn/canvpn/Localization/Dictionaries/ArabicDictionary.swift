//
//  ArabicDictionary.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.08.2023.
//

import Foundation

// ar
struct ArabicDictionary {
    static let values: [String: String] = [
        "connect_key" : "يتصل",
        "connecting_key": "توصيل",
        "connected_key": "متصل",
        "disconnect_key" : "قطع الاتصال",
        "disconnected_key": "انقطع الاتصال",
        "disconnecting_key": "قطع الاتصال",
        "initial_key": "انقر للبدء",
        "privacy_policy_key": "سياسة الخصوصية",
        "terms_of_service_key": "شروط الاستخدام",
        "pp_tos_key": "باستخدام التطبيق ، فإنك توافق على شروط الاستخدام وسياسة الخصوصية.",
        "current_ip_key": "IP الحالي",
        "error_occur_reload" : "حدث خطأ ، يرجى إعادة تحميل التطبيق.",
        "error_occur_location" : "حدث خطأ ، يرجى تحديد موقع من قبل.",
        "error_try_again" : "حدث خطأ ، يرجى المحاولة مرة أخرى.",
        "error_location_again" : "حدث خطأ ، يرجى تحديد الموقع مرة أخرى!",
        "choose_location": "اختيار موقع",
        "premium_desc_1": "إخفاء عنوان IP الخاص بك مع تصفح مجهول",
        "premium_desc_2": "عرض نطاق ترددي يصل إلى 1000 ميجابت / ثانية للاستكشاف",
        "premium_desc_3": "اختر بحرية من بين أكثر من 10 مواقع.",
        "premium_desc_4": "نقل حركة المرور عبر النفق المشفر",
        "premium_title_1": "مجهول",
        "premium_title_2": "سريع",
        "premium_title_3": "10+ الموقع",
        "premium_title_4": "يؤمن",
        "upgrade_pro": "التطور للاحترافية",
        "upgrade_pro_detail": "جرب Premium مجانًا ، وقم بالإلغاء في أي وقت.",
        "premium_feature_title": "العضوية المميزة",
        "error_on_restore_title": "فشل في استعادة الاشتراك.",
        "error_on_restore_desc": "ليس لديك اشتراك نشط.",
        "ok_button_key": "موافق",
        "error_on_productId": "لم يتم العثور على معرف منتج الاشتراك.",
        "error_on_product": "لم يتم العثور على منتج الاشتراك.",
        "error_on_product_request": "تعذر الحصول على منتجات الاشتراك المتاحة في الوقت الحالي.",
        "error_on_payment": "تم إلغاء عملية الاشتراك.",
        "subscribe_button_key": "اشترك الآن",
        "subs_terms_key": "شروط الاشتراك",
        "subs_restore_key": "استعادة الاشتراك",
        "subs_terms_detail_key" : "نقدم اشتراكات أسبوعية وشهرية وسنوية ومدى الحياة تقدم خصومات على السعر الشهري. الأسعار معروضة بوضوح في التطبيق.\n- سيتم خصم الدفع من حساب iTunes الخاص بك عند تأكيد الشراء.\n- سيتم تجديد اشتراكك تلقائيًا ما لم يتم إيقاف التجديد التلقائي قبل 24 ساعة على الأقل من نهاية الفترة الحالية.\n- سيتم محاسبة حسابك على التجديد خلال 24 ساعة قبل نهاية الفترة الحالية.\n- يمكنك إدارة اشتراكاتك وإيقاف التجديد التلقائي من خلال الذهاب إلى إعدادات الحساب في متجر iTunes.\n- إذا تم العرض، إذا اخترت استخدام النسخة التجريبية المجانية لدينا، فسيتم الاستغناء عن أي جزء غير مستخدم من فترة التجربة المجانية عند شراء اشتراك لهذا الإصدار، حيث ينطبق.\n- إذا قررت عدم شراء iLove VPN، يمكنك متابعة استخدام والاستمتاع بـ iLove VPN مجانًا.\nيتم تخزين البيانات الشخصية الخاصة بك بأمان على iLove VPN، تأكد من قراءة سياسة الخصوصية وشروط الاستخدام لدينا.",
        "upgraded_to_pro": "مستخدم مميز",
        "upgraded_to_pro_detail": "يمكنك استخدام جميع المواقع كمستخدم مميز.",
        "free_user_selected_premium_message": "يجب أن تشترك لاستخدام موقع مميز",
        "try_coupon_code_key": "جرب كود القسيمة",
        "enter_coupon_code": "أدخل كود القسيمة",
        "coupon_code_placeholder": "كود القسيمة",
        "coupon_alert_cancel": "إلغاء",
        "coupon_alert_try": "جرب",
        "best_tag": "أفضل عرض",
        "discount_tag": "خصم",
        "unknown_product_title": "منتج غير معروف",
        "congrats_title": "تهانينا!",
        "get_free_popup_description": "لقد فزت بفرصة للحصول على دعوة لعضوية مميزة لمدة شهر واحد مع حسابك عبر رمز ترويجي حصري. \nفقط قدم بريدك الإلكتروني، ويمكنك بدء تجربة مزايا الوصول المميزة.",
        "get_free_popup_email_placeholder": "أدخل بريدك الإلكتروني",
        "get_free_popup_get_code": "احصل على الرمز",
        "get_free_popup_empty_email_error": "لا يمكن ترك حقل البريد الإلكتروني فارغًا!",
        "ERROR_TIMEOUT" : "تمت إطالة الوقت المخصص للاستجابة من الخادم. يُرجى المحاولة مرة أخرى.",
        "ERROR_INVALID_ENDPOINT" : "حدث خطأ داخلي في الخادم أثناء معالجة الطلب. يُرجى المحاولة مرة أخرى.",
        "ERROR_SERVER_ERROR" : "حدث خطأ داخلي في الخادم أثناء معالجة الطلب.",
        "ERROR_COUPON_NOT_FOUND" : "تعذر العثور على رمز الكوبون المطلوب.",
        "ERROR_COUPON_EXPIRED" : "انتهت صلاحية رمز الكوبون ولم يعد صالحًا.",
        "ERROR_UNKNOWN" : "حدث خطأ غير معروف. يُرجى المحاولة مرة أخرى.",
        "ERROR_EMAIL_INVALID": "عنوان البريد الإلكتروني المُقدم غير صالح.",
        "coupon_generate_success": "تم إرسال القسيمة إلى عنوان البريد الإلكتروني الخاص بك!"
    ]
}

