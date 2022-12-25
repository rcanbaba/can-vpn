//
//  VpnServerModel.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import Foundation

struct VpnServerItem {
    var ip: String
    var username: String
    var password: String
    var secret: String
    var isFree: Bool
    var region: String
    var country: String
    var countryCode: String
    var isSelected: Bool = false
}


//[{"ip":"3.86.250.76","username":"vpnserver","password":"vpnserver","secret":"vpnserver","bool":true,"region":"Northern Virginia","country":"United States of America","country_code":"us"}]
