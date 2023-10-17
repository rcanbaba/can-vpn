//
//  IndonesianDictionary.swift
//  canvpn
//
//  Created by Can Babaoğlu on 13.10.2023.
//

// id
struct IndonesianDictionary {
    static let values: [String: String] = [
        "connect_key" : "Terhubung",
        "connecting_key": "Menghubungkan",
        "connected_key": "Terhubung",
        "disconnect_key" : "Putus",
        "disconnected_key": "Terputus",
        "disconnecting_key": "Memutuskan",
        "initial_key": "Ketuk untuk memulai",
        "privacy_policy_key": "Kebijakan Privasi",
        "terms_of_service_key": "Syarat Penggunaan",
        "pp_tos_key": "Dengan menggunakan aplikasi ini, Anda menyetujui Syarat Penggunaan dan Kebijakan Privasi.",
        "current_ip_key": "IP Saat Ini",
        "error_occur_reload" : "Terjadi kesalahan, silakan muat ulang aplikasi.",
        "error_occur_location" : "Terjadi kesalahan, silakan pilih lokasi terlebih dahulu.",
        "error_try_again" : "Terjadi kesalahan, silakan coba lagi.",
        "error_location_again" : "Terjadi kesalahan, silakan pilih lokasi lagi!",
        "choose_location": "Pilih Lokasi",
        "premium_desc_1": "Sembunyikan IP Anda dengan berselancar secara anonim.",
        "premium_desc_2": "Lebar pita hingga 1000 Mb/detik untuk menjelajah",
        "premium_desc_3": "Pilih bebas dari 10+ lokasi.",
        "premium_desc_4": "Transfer lalu lintas melalui terowongan terenkripsi.",
        "premium_title_1": "Anonim",
        "premium_title_2": "Cepat",
        "premium_title_3": "10+ Lokasi",
        "premium_title_4": "Aman",
        "upgrade_pro": "Upgrade ke PRO",
        "upgrade_pro_detail": "Coba premium gratis, batalkan kapan saja.",
        "premium_feature_title": "Fitur Premium",
        "error_on_restore_title": "Gagal mengembalikan langganan.",
        "error_on_restore_desc": "Anda tidak memiliki langganan aktif.",
        "ok_button_key": "Ok",
        "error_on_productId": "Identifier produk langganan tidak ditemukan.",
        "error_on_product": "Produk langganan tidak ditemukan.",
        "error_on_product_request": "Tidak dapat mengambil produk langganan yang tersedia saat ini.",
        "error_on_payment": "Proses langganan telah dibatalkan.",
        "subscribe_button_key": "BERLANGGANAN SEKARANG",
        "subs_terms_key": "Syarat Langganan",
        "subs_restore_key": "Pulihkan Langganan",
        "subs_terms_detail_key" : "Kami menawarkan tiga durasi langganan utama dengan opsi harga diskon saat menggunakan kode diskon yang tersedia. Harga dan penawaran sebagai berikut:\n\n1. Tarif Langganan Standar:\n    - 1 Bulan: 11,99€\n    - 6 Bulan: 59,94€ (9,99€/bulan)\n    - 12 Bulan: 95,88€ (7,99€/bulan)\n\n2. Penawaran Khusus:\n    - Daftar dengan email dan/atau referensikan teman untuk menikmati langganan gratis selama 1 bulan.\n\n3. Dengan Kode Diskon:\n    - 1 Bulan: 8,49€\n    - 6 Bulan: 38,94€ (6,49€/bulan)\n    - 12 Bulan: 65,88€ (5,49€/bulan)\n\nHarga ditampilkan dengan jelas di aplikasi.\n- Pembayaran akan dibebankan ke akun iTunes Anda setelah konfirmasi pembelian.\n- Langganan Anda akan diperbarui secara otomatis kecuali pembatalan otomatis dimatikan setidaknya 24 jam sebelum akhir periode saat ini.\n- Akun Anda akan dikenakan biaya perpanjangan dalam waktu 24 jam sebelum akhir periode saat ini.\n- Kelola langganan Anda dan nonaktifkan perpanjangan otomatis dengan pergi ke Pengaturan Akun Anda di toko iTunes.\n- Jika ditawarkan, bagian yang tidak digunakan dari periode uji coba gratis akan hilang saat membeli langganan.\n- Jika Anda tidak memilih untuk membeli iLove VPN, Anda dapat terus menggunakannya secara gratis.\nData pribadi Anda disimpan dengan aman di iLove VPN. Harap baca Kebijakan Privasi dan Syarat Penggunaan kami untuk detail lebih lanjut.",
        "upgraded_to_pro": "Pengguna Premium",
        "upgraded_to_pro_detail": "Anda dapat menggunakan semua lokasi sebagai premium.",
        "free_user_selected_premium_message": "Anda perlu berlangganan untuk menggunakan lokasi premium",
        "try_coupon_code_key": "Coba Kode Kupon",
        "enter_coupon_code": "Masukkan Kode Kupon",
        "coupon_code_placeholder": "Kode Kupon",
        "coupon_alert_cancel": "Batal",
        "coupon_alert_try": "Coba",
        "best_tag": "Penawaran Terbaik",
        "discount_tag": "Diskon",
        "unknown_product_title": "Produk Tidak Dikenal",
        "congrats_title": "Selamat!",
        "get_free_popup_description": "Anda memenangkan kesempatan untuk undangan keanggotaan premium selama satu bulan dengan akun Anda melalui kode promo eksklusif. \nCukup berikan alamat email Anda, dan Anda dapat mulai merasakan manfaat akses premium.",
        "get_free_popup_email_placeholder": "Masukkan alamat email Anda",
        "get_free_popup_get_code": "Dapatkan Kode",
        "get_free_popup_empty_email_error": "Email tidak boleh kosong!",
        "ERROR_TIMEOUT" : "Permintaan ke server telah habis waktu. Silakan coba lagi.",
        "ERROR_INVALID_ENDPOINT" : "Terjadi kesalahan internal server saat memproses permintaan. Silakan coba lagi.",
        "ERROR_SERVER_ERROR" : "Terjadi kesalahan internal server saat memproses permintaan.",
        "ERROR_COUPON_NOT_FOUND" : "Kode kupon yang diminta tidak dapat ditemukan.",
        "ERROR_COUPON_EXPIRED" : "Kode kupon telah kedaluwarsa dan tidak lagi valid.",
        "ERROR_UNKNOWN" : "Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.",
        "ERROR_EMAIL_INVALID": "Alamat email yang diberikan tidak valid.",
        "coupon_generate_success": "Kode kupon telah dikirim ke alamat email Anda!",
        "FAQ_contactUs_key": "Butuh bantuan? Kunjungi Tanya Jawab atau hubungi kami melalui Hubungi Kami.",
        "FAQ_key": "Tanya Jawab",
        "contactUs_key": "Hubungi Kami"
    ]
}
