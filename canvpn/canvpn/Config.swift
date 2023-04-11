//
//  Config.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import Foundation
import WireGuardKit

var SERVER_PUBLIC_KEY_5 = PublicKey(base64Key: "18jMWwySbkV2RPhVY66aSgVBtldmoZuTTpfJrmN4FE4=")!

var ALLOWED_IPS_5_1 = IPAddressRange(from: "0.0.0.0/0")!
var ALLOWED_IPS_5_2 = IPAddressRange(from: "::/0")!

var SERVER_ENDPOINT_STRING_5 = "34.244.1.166:51820"
var SERVER_ENDPOINT_5 = Endpoint(from: SERVER_ENDPOINT_STRING_5)

var SERVER_PRESHARED_KEY_5 = PreSharedKey(base64Key: "CNwuP+ZUKGGCfLi6v5unFU2DP4Smg+bYGvzNBbt5Bbs=")!

var SERVER_PRIVATE_KEY_5 = PrivateKey(base64Key: "0I3a72VsxzF2SC/54xKsnGafsC5nVkOYHw12eNZu/NQ=")!

var CLIENT_DNS_5_1 = DNSServer(from: "1.1.1.1")!
var CLIENT_DNS_5_2 = DNSServer(from: "1.0.0.1")!

var ADDRESS_5_1 = IPAddressRange(from: "10.3.2.218/32")!
var ADDRESS_5_2 = IPAddressRange(from: "fd00::3:2:7f/128")!
