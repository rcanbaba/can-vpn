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
        "error_occur_reload" : "Hata oluştu, uygulamayı tekrar çalıştırınız.",
        "error_occur_location" : "Hata oluştu, lütfen konum seçiniz.",
        "error_try_again" : "Hata oluştu, lütfen tekrar deneyiniz.",
        "error_location_again" : "Hata oluştu, lütfen konumu tekrar seçiniz!",
        "choose_location": "Konum Seç",
        "premium_desc_1": "Ip adresinizi gizleyin anonim olarak gezinin.",
        "premium_desc_2": "1000 Mb/s e varan bant genişliği",
        "premium_desc_3": "Reklamsız uygulama keyfi",
        "premium_desc_4": "Şifrelenmiş bağlantı ile gizli kalın.",
        "premium_title_1": "Anonim",
        "premium_title_2": "Hızlı",
        "premium_title_3": "Reklamsız",
        "premium_title_4": "Güveli",
        "upgrade_pro": "Premiuma Yükselt",
        "upgrade_pro_detail": "Ücretsiz Premiumu dene, istediğin zaman iptal et.",
        "premium_feature_title": "Premium Özellikler",
        "error_on_restore_title": "Abonelik yenilenemedi.",
        "error_on_restore_desc": "Aktif aboneliğiniz bulunamadı.",
        "ok_button_key": "Tamam",
        "error_on_productId": "Abonelik ürün bilgileri bulunamadı.",
        "error_on_product": "Abonelik ürünleri bulunamadı.",
        "error_on_product_request": "Uygun abonelik türlerine şu an erişilemiyor.",
        "error_on_payment": "Abonelik işlemi iptal edildi.",
        "subscribe_button_key": "Aboneliği Başlat",
        "subs_terms_key": "Abonelik Şartları",
        "subs_restore_key": "Aboneliği Yenile",
        "subs_terms_detail_key" : "We offer monthly, 3-month, 6-month, 1-year and lifetime subscriptions giving discounts to the monthly price. Prices are clearly displayed in the app.\n- Payment will be charged to your iTunes account at confirmation of purchase.\n- Your subscription will automatically renew itself unless auto-renewal is turned off at least 24 hours before the end of the current period.\n- Your account will be charged for renewal within 24 hours prior to the end of the current period.\n- You can manage your subscriptions and turn off auto-renewal by going to your Account Settings in the iTunes store.\n- If offered, if you choose to use our free trial, any unused portion of the free trial period will be forfeited when you purchase a subscription to that publication, where applicable.\n- If you don't choose to purchase Cleanup Pro, you can simply continue using and enjoying Cleaner Pro for free.\nYour personal data is securely stored on Cleaner Pro, be sure to read our Privacy Policy and Terms of Use.",
        "upgraded_to_pro": "Premium Kullanıcı",
        "upgraded_to_pro_detail": "Premium olarak tüm konumları kullanabiliyorsunuz."
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
        "premium_feature_title": "Premium Features",
        "error_on_restore_title": "Failed to restore subscription.",
        "error_on_restore_desc": "You don’t have an active subscription.",
        "ok_button_key": "Ok",
        "error_on_productId": "Subscription product identifier not found.",
        "error_on_product": "Subscription product not found.",
        "error_on_product_request": "Unable to fetch available subscription products at the moment.",
        "error_on_payment": "Subscription process was cancelled.",
        "subscribe_button_key": "SUBSCRIBE NOW",
        "subs_terms_key": "Subscription Terms",
        "subs_restore_key": "Restore Subscription",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    private var arDictionary = [
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
        "premium_desc_3": "استمتع بالتطبيق بدون إعلانات مزعجة",
        "premium_desc_4": "نقل حركة المرور عبر النفق المشفر",
        "premium_title_1": "مجهول",
        "premium_title_2": "سريع",
        "premium_title_3": "ازالة الاعلانات",
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
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    private var esDictionary = [
        "connect_key": "Conectar",
        "connecting_key": "Conectando",
        "connected_key": "Conectado",
        "disconnect_key": "Desconectar",
        "disconnected_key": "Desconectado",
        "disconnecting_key": "Desconectando",
        "initial_key": "Toca para comenzar",
        "privacy_policy_key": "Política de privacidad",
        "terms_of_service_key": "Términos de uso",
        "pp_tos_key": "Al utilizar la aplicación, aceptas los Términos de uso y la Política de privacidad.",
        "current_ip_key": "IP actual",
        "error_occur_reload": "Se produjo un error, por favor vuelve a cargar la aplicación.",
        "error_occur_location": "Se produjo un error, por favor selecciona una ubicación antes.",
        "error_try_again": "Se produjo un error, por favor inténtalo nuevamente.",
        "error_location_again": "Se produjo un error, por favor selecciona la ubicación nuevamente.",
        "choose_location": "Selecciona una ubicación",
        "premium_desc_1": "Oculta tu IP con navegación anónima",
        "premium_desc_2": "Ancho de banda de hasta 1000 Mb/s para explorar",
        "premium_desc_3": "Disfruta de la aplicación sin anuncios molestos",
        "premium_desc_4": "Transfiere el tráfico a través de un túnel encriptado",
        "premium_title_1": "Anónimo",
        "premium_title_2": "Rápido",
        "premium_title_3": "Eliminar anuncios",
        "premium_title_4": "Seguro",
        "upgrade_pro": "Actualizar a PRO",
        "upgrade_pro_detail": "Prueba premium gratis, cancela en cualquier momento.",
        "premium_feature_title": "Funciones premium",
        "error_on_restore_title": "Error al restaurar la suscripción.",
        "error_on_restore_desc": "No tienes una suscripción activa.",
        "ok_button_key": "Ok",
        "error_on_productId": "No se encontró el identificador del producto de suscripción.",
        "error_on_product": "No se encontró el producto de suscripción.",
        "error_on_product_request": "No se pueden obtener los productos de suscripción disponibles en este momento.",
        "error_on_payment": "Se canceló el proceso de suscripción.",
        "subscribe_button_key": "SUSCRÍBETE AHORA",
        "subs_terms_key": "Términos de suscripción",
        "subs_restore_key": "Restaurar suscripción",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    private var frDictionary = [
        "connect_key": "Connexion",
        "connecting_key": "Connexion en cours",
        "connected_key": "Connecté",
        "disconnect_key": "Déconnexion",
        "disconnected_key": "Déconnecté",
        "disconnecting_key": "Déconnexion en cours",
        "initial_key": "Appuyez pour commencer",
        "privacy_policy_key": "Politique de confidentialité",
        "terms_of_service_key": "Conditions d'utilisation",
        "pp_tos_key": "En utilisant l'application, vous acceptez les Conditions d'utilisation et la Politique de confidentialité.",
        "current_ip_key": "IP actuelle",
        "error_occur_reload": "Une erreur est survenue, veuillez recharger l'application.",
        "error_occur_location": "Une erreur est survenue, veuillez sélectionner une localisation auparavant.",
        "error_try_again": "Une erreur est survenue, veuillez réessayer.",
        "error_location_again": "Une erreur est survenue, veuillez sélectionner à nouveau la localisation.",
        "choose_location": "Choisir une localisation",
        "premium_desc_1": "Masquez votre IP avec une navigation anonyme",
        "premium_desc_2": "Bande passante jusqu'à 1000 Mb/s pour explorer",
        "premium_desc_3": "Profitez de l'application sans publicité gênante",
        "premium_desc_4": "Transférez le trafic via un tunnel chiffré",
        "premium_title_1": "Anonyme",
        "premium_title_2": "Rapide",
        "premium_title_3": "Supprimer les publicités",
        "premium_title_4": "Sécurisé",
        "upgrade_pro": "Passer à la version PRO",
        "upgrade_pro_detail": "Essayez Premium gratuitement, annulez à tout moment.",
        "premium_feature_title": "Fonctionnalités Premium",
        "error_on_restore_title": "Échec de la restauration de l'abonnement.",
        "error_on_restore_desc": "Vous n'avez pas d'abonnement actif.",
        "ok_button_key": "Ok",
        "error_on_productId": "Identifiant du produit d'abonnement introuvable.",
        "error_on_product": "Produit d'abonnement introuvable.",
        "error_on_product_request": "Impossible de récupérer les produits d'abonnement disponibles pour le moment.",
        "error_on_payment": "Le processus d'abonnement a été annulé.",
        "subscribe_button_key": "S'ABONNER MAINTENANT",
        "subs_terms_key": "Conditions d'abonnement",
        "subs_restore_key": "Restaurer l'abonnement",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    private var deDictionary = [
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
        "premium_desc_3": "Genießen Sie die App ohne störende Werbung",
        "premium_desc_4": "Übertragen Sie den Datenverkehr über einen verschlüsselten Tunnel",
        "premium_title_1": "Anonym",
        "premium_title_2": "Schnell",
        "premium_title_3": "Werbung entfernen",
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
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    // zh-Hans, zh-Hant, zh-HK
    private var zhDictionary = [
        "connect_key": "连接",
        "connecting_key": "连接中",
        "connected_key": "已连接",
        "disconnect_key": "断开连接",
        "disconnected_key": "已断开",
        "disconnecting_key": "断开连接中",
        "initial_key": "点击开始",
        "privacy_policy_key": "隐私政策",
        "terms_of_service_key": "使用条款",
        "pp_tos_key": "使用本应用即表示您同意遵守使用条款和隐私政策。",
        "current_ip_key": "当前 IP",
        "error_occur_reload": "发生错误，请重新加载应用。",
        "error_occur_location": "发生错误，请先选择位置。",
        "error_try_again": "发生错误，请重试。",
        "error_location_again": "发生错误，请重新选择位置！",
        "choose_location": "选择位置",
        "premium_desc_1": "使用匿名浏览隐藏您的 IP",
        "premium_desc_2": "高达 1000 Mb/s 的带宽来探索",
        "premium_desc_3": "无广告，尽情享受应用",
        "premium_desc_4": "通过加密隧道传输流量",
        "premium_title_1": "匿名",
        "premium_title_2": "快速",
        "premium_title_3": "去除广告",
        "premium_title_4": "安全",
        "upgrade_pro": "升级到 PRO 版",
        "upgrade_pro_detail": "免费尝试高级版，随时取消。",
        "premium_feature_title": "高级功能",
        "error_on_restore_title": "恢复订阅失败。",
        "error_on_restore_desc": "您没有有效的订阅。",
        "ok_button_key": "确定",
        "error_on_productId": "未找到订阅产品标识。",
        "error_on_product": "未找到订阅产品。",
        "error_on_product_request": "暂时无法获取可用的订阅产品。",
        "error_on_payment": "订阅过程已取消。",
        "subscribe_button_key": "立即订阅",
        "subs_terms_key": "订阅条款",
        "subs_restore_key": "恢复订阅",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    // fa persian
    private var faDictionary = [
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
        "premium_desc_3": "لذت بردن از برنامه بدون تبلیغات آزاردهنده",
        "premium_desc_4": "انتقال ترافیک از طریق تونل رمزنگاری شده",
        "premium_title_1": "ناشناس",
        "premium_title_2": "سریع",
        "premium_title_3": "حذف تبلیغات",
        "premium_title_4": "امن",
        "upgrade_pro": "ارتقا به نسخه PRO",
        "upgrade_pro_detail": "آزمایش رایگان نسخه پرمیوم، هر زمان قابل لغو است.",
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
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    // ur Urdu
    private var urDictionary = [
        "connect_key": "منسلک کریں",
        "connecting_key": "منسلک ہو رہا ہے",
        "connected_key": "منسلک",
        "disconnect_key": "منسلکی ختم کریں",
        "disconnected_key": "منسلکی ختم ہوگئی",
        "disconnecting_key": "منسلکی ختم ہو رہی ہے",
        "initial_key": "شروع کرنے کے لئے ٹیپ کریں",
        "privacy_policy_key": "پرائیویسی پالیسی",
        "terms_of_service_key": "استعمال کی شرائط",
        "pp_tos_key": "اپلیکیشن استعمال کرتے ہوئے، آپ استعمال کی شرائط اور پرائیویسی پالیسی سے اتفاق کرتے ہیں۔",
        "current_ip_key": "موجودہ IP",
        "error_occur_reload": "ایک خطا واقع ہوئی ہے، براہ کرم ایپ دوبارہ بارگذاری کریں۔",
        "error_occur_location": "ایک خطا واقع ہوئی ہے، براہ کرم جاری رکھنے سے پہلے ایک لوکیشن منتخب کریں۔",
        "error_try_again": "ایک خطا واقع ہوئی ہے، براہ کرم دوبارہ کوشش کریں۔",
        "error_location_again": "ایک خطا واقع ہوئی ہے، براہ کرم لوکیشن دوبارہ منتخب کریں!",
        "choose_location": "لوکیشن منتخب کریں",
        "premium_desc_1": "خود کو ناشناس سرفہرستی سے چھپائیں",
        "premium_desc_2": "کھوج کے لئے تازہ کاری تک میگابائٹ فی سیکنڈ تک بینڈوڈ",
        "premium_desc_3": "تکلیف دہ اشتہارات کے بغیر ایپ کا لطف اٹھائیں",
        "premium_desc_4": "خفیہٗ مفتولی تونل کے ذریعہ ٹریفک منتقل کریں",
        "premium_title_1": "ناشناس",
        "premium_title_2": "تیز",
        "premium_title_3": "اشتہارات ہٹائیں",
        "premium_title_4": "محفوظ",
        "upgrade_pro": "PRO کو اپ گریڈ کریں",
        "upgrade_pro_detail": "پریمیم کو فوری آزمائیں، کسی بھی وقت منسوخ کریں۔",
        "premium_feature_title": "پریمیم خصوصیات",
        "error_on_restore_title": "اشتراک بحال کرنے میں ناکامی ہوئی۔",
        "error_on_restore_desc": "آپ کے پاس کوئی فعال اشتراک نہیں ہے۔",
        "ok_button_key": "ٹھیک ہے",
        "error_on_productId": "اشتراک پروڈکٹ کا شناخت کار نہیں ملا۔",
        "error_on_product": "اشتراک پروڈکٹ نہیں ملا۔",
        "error_on_product_request": "فی الحال دستیاب اشتراک پروڈکٹس کو حاصل کرنے میں ناکامی۔",
        "error_on_payment": "اشتراک کی پروسیس منسوخ کردی گئی۔",
        "subscribe_button_key": "ابھی سبسکرائب کریں",
        "subs_terms_key": "سبسکرپشن کی شرائط",
        "subs_restore_key": "سبسکرپشن بحال کریں",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    private var ruDictionary = [
        "connect_key": "Подключиться",
        "connecting_key": "Подключение",
        "connected_key": "Подключено",
        "disconnect_key": "Отключиться",
        "disconnected_key": "Отключено",
        "disconnecting_key": "Отключение",
        "initial_key": "Нажмите для запуска",
        "privacy_policy_key": "Политика конфиденциальности",
        "terms_of_service_key": "Условия использования",
        "pp_tos_key": "Используя приложение, вы соглашаетесь с Условиями использования и Политикой конфиденциальности.",
        "current_ip_key": "Текущий IP",
        "error_occur_reload": "Произошла ошибка, пожалуйста, перезагрузите приложение.",
        "error_occur_location": "Произошла ошибка, пожалуйста, выберите местоположение.",
        "error_try_again": "Произошла ошибка, пожалуйста, попробуйте еще раз.",
        "error_location_again": "Произошла ошибка, пожалуйста, выберите местоположение еще раз!",
        "choose_location": "Выберите местоположение",
        "premium_desc_1": "Скройте свой IP с анонимным серфингом",
        "premium_desc_2": "Скорость до 1000 Мбит/с для исследований",
        "premium_desc_3": "Наслаждайтесь приложением без раздражающих объявлений",
        "premium_desc_4": "Передача трафика через зашифрованный туннель",
        "premium_title_1": "Анонимность",
        "premium_title_2": "Быстрота",
        "premium_title_3": "Удаление рекламы",
        "premium_title_4": "Безопасность",
        "upgrade_pro": "Получите PRO",
        "upgrade_pro_detail": "Попробуйте премиум-версию бесплатно, отмена в любое время.",
        "premium_feature_title": "Премиум-функции",
        "error_on_restore_title": "Не удалось восстановить подписку.",
        "error_on_restore_desc": "У вас нет активной подписки.",
        "ok_button_key": "Ок",
        "error_on_productId": "Идентификатор подписки не найден.",
        "error_on_product": "Подписка не найдена.",
        "error_on_product_request": "Не удалось получить доступные продукты подписки в данный момент.",
        "error_on_payment": "Процесс подписки был отменен.",
        "subscribe_button_key": "ПОДПИСАТЬСЯ СЕЙЧАС",
        "subs_terms_key": "Условия подписки",
        "subs_restore_key": "Восстановить подписку",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    // hindi hi
    private var hiDictionary = [
        "connect_key": "कनेक्ट करें",
        "connecting_key": "कनेक्ट हो रहा है",
        "connected_key": "कनेक्टेड",
        "disconnect_key": "डिस्कनेक्ट करें",
        "disconnected_key": "डिस्कनेक्टेड",
        "disconnecting_key": "डिस्कनेक्ट हो रहा है",
        "initial_key": "स्टार्ट करने के लिए टैप करें",
        "privacy_policy_key": "गोपनीयता नीति",
        "terms_of_service_key": "उपयोग की शर्तें",
        "pp_tos_key": "एप्लिकेशन का उपयोग करके आप उपयोग की शर्तें और गोपनीयता नीति स्वीकार करते हैं।",
        "current_ip_key": "वर्तमान आईपी",
        "error_occur_reload": "त्रुटि हुई, कृपया ऐप रीलोड करें।",
        "error_occur_location": "त्रुटि हुई, कृपया पहले स्थान चुनें।",
        "error_try_again": "त्रुटि हुई, कृपया पुनः प्रयास करें।",
        "error_location_again": "त्रुटि हुई, कृपया स्थान फिर से चुनें!",
        "choose_location": "स्थान चुनें",
        "premium_desc_1": "गुमनाम सर्फिंग के साथ अपना आईपी छिपाएं",
        "premium_desc_2": "खोज के लिए 1000 एमबीपीएस तक की बैंडविड्थ",
        "premium_desc_3": "विज्ञापनों के बिना ऐप का आनंद लें",
        "premium_desc_4": "एन्क्रिप्टेड टनल के माध्यम से ट्रैफिक ट्रांसफर करें",
        "premium_title_1": "गुमनाम",
        "premium_title_2": "तेज",
        "premium_title_3": "विज्ञापनों को हटाएं",
        "premium_title_4": "सुरक्षित",
        "upgrade_pro": "प्रो में अपग्रेड करें",
        "upgrade_pro_detail": "प्रीमियम को मुफ्त में आज़माएं, कभी भी रद्द करें।",
        "premium_feature_title": "प्रीमियम सुविधाएँ",
        "error_on_restore_title": "सदस्यता को बहाल करने में विफल हुआ।",
        "error_on_restore_desc": "आपके पास कोई सक्रिय सदस्यता नहीं है।",
        "ok_button_key": "ठीक है",
        "error_on_productId": "सदस्यता उत्पाद आईडेंटिफ़ायर नहीं मिला।",
        "error_on_product": "सदस्यता उत्पाद नहीं मिला।",
        "error_on_product_request": "वर्तमान में उपलब्ध सदस्यता उत्पादों को प्राप्त करने में असमर्थ।",
        "error_on_payment": "सदस्यता प्रक्रिया रद्द कर दी गई थी।",
        "subscribe_button_key": "अभी सदस्यता लें",
        "subs_terms_key": "सदस्यता नियम",
        "subs_restore_key": "सदस्यता को पुनर्स्थापित करें",
        "subs_terms_detail_key" : "TODO TODO TODO"
    ]
    
    
    public func getDictionary(language: LanguageEnum) -> [String : String] {
        switch language {
        case .tr:
            return trDictionary
        case .eng:
            return engDictionary
        case .ar:
            return arDictionary
        case .es:
            return esDictionary
        case .fr:
            return frDictionary
        case .de:
            return deDictionary
        case .zh:
            return zhDictionary
        case .fa:
            return faDictionary
        case .ur:
            return urDictionary
        case .ru:
            return ruDictionary
        case .hi:
            return hiDictionary
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
        return Dictionaries().getDictionary(language: lang)[key] ?? ""    }
    
}

extension String {
    func localize() -> String {
        return LocalizationManager.localize(key: self)
    }
    
}
