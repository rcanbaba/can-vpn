//
//  Config.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import Foundation
import WireGuardKit

<<<<<<< Updated upstream
var SERVER_PUBLIC_KEY_5 = PublicKey(base64Key: "18jMWwySbkV2RPhVY66aSgVBtldmoZuTTpfJrmN4FE4=")!

var ALLOWED_IPS_5_1 = IPAddressRange(from: "0.0.0.0/0")!
var ALLOWED_IPS_5_2 = IPAddressRange(from: "::/0")!
=======
// The client's WireGuard private key.
var CLIENT_PRIVATE_KEY = PrivateKey(base64Key: "OBSp74gbmSHtZjpD7q9Kzldwz8HGR5xZwZM4mClcV0Q=")!

// The client's virtual IP address for WireGuard.
var CLIENT_IP = IPAddressRange(from: "10.66.66.3")!
>>>>>>> Stashed changes

var SERVER_ENDPOINT_STRING_5 = "34.244.1.166:51820"
var SERVER_ENDPOINT_5 = Endpoint(from: SERVER_ENDPOINT_STRING_5)

<<<<<<< Updated upstream
var SERVER_PRESHARED_KEY_5 = PreSharedKey(base64Key: "CNwuP+ZUKGGCfLi6v5unFU2DP4Smg+bYGvzNBbt5Bbs=")!

var SERVER_PRIVATE_KEY_5 = PrivateKey(base64Key: "0I3a72VsxzF2SC/54xKsnGafsC5nVkOYHw12eNZu/NQ=")!

var CLIENT_DNS_5_1 = DNSServer(from: "1.1.1.1")!
var CLIENT_DNS_5_2 = DNSServer(from: "1.0.0.1")!

var ADDRESS_5_1 = IPAddressRange(from: "10.3.2.218/32")!
var ADDRESS_5_2 = IPAddressRange(from: "fd00::3:2:7f/128")!
=======
// The DNS server to use for the client.
var CLIENT_DNS = DNSServer(from: "1.1.1.1")!

// The server's WireGuard public key.
var SERVER_PUBLIC_KEY = PublicKey(base64Key: "4mr2idcjAD/1ql6DbH76gnrcZJCyBKGk/zoZ2tv4URY=")!

// The server's IP address and port, such as "1.2.3.4:51820" or similar.
var SERVER_ENDPOINT_STRING = "15.237.93.242:57630"

// The server's endpoint, generated from `SERVER_ENDPOINT_STRING`.
var SERVER_ENDPOINT = Endpoint(from: SERVER_ENDPOINT_STRING)



// TODO: BUNLAR LAZIM

let SERVER_PUBLIC_KEY_3 = PublicKey(base64Key: "upS8vveb1QW/rr1B9Zdu59tw5O4XWrpndX/Kpg6pGWw=")!

let IP_ADDRESS_RANGE_3_1 = IPAddressRange(from: "0.0.0.0/0")!
let IP_ADDRESS_RANGE_3_2 = IPAddressRange(from: "0.0.0.0/0")!

var SERVER_ENDPOINT_STRING_3 = "15.237.93.242:57630"
var SERVER_ENDPOINT_3 = Endpoint(from: SERVER_ENDPOINT_STRING)

let SERVER_PRESHARED_KEY_3 = PreSharedKey(base64Key: "e3qTVsUa8rlotL8xaw+512Wr74PWO35QzYLI+bWzd1M=")!

let SERVER_PRIVATE_KEY_3 = PrivateKey(base64Key: "GCOyjmHQ2VQXvnwnVGmkAoiXhWThSn7t69rB4D/pgmw=")!

let CLIENT_DNS_3_1 = DNSServer(from: "94.140.14.14")!
let CLIENT_DNS_3_2 = DNSServer(from: "94.140.15.15")!

let CLIENT_IP_3_1 = IPAddressRange(from: "10.66.66.3/32")!
let CLIENT_IP_3_2 = IPAddressRange(from: "fd42:42:42::3/128")!


// TODO: BUNLAR DIŞARDAN SET ETTİM

var SERVER_PUBLIC_KEY_2 = PublicKey(base64Key: "upS8vveb1QW/rr1B9Zdu59tw5O4XWrpndX/Kpg6pGWw=")!

var ALLOWED_IPS_2_1 = IPAddressRange(from: "0.0.0.0/0")!
var ALLOWED_IPS_2_2 = IPAddressRange(from: "0.0.0.0/0")!

var SERVER_ENDPOINT_STRING_2 = "15.237.93.242:57630"
var SERVER_ENDPOINT_2 = Endpoint(from: SERVER_ENDPOINT_STRING)

var SERVER_PRESHARED_KEY_2 = PreSharedKey(base64Key: "e3qTVsUa8rlotL8xaw+512Wr74PWO35QzYLI+bWzd1M=")!

var SERVER_PRIVATE_KEY_2 = PrivateKey(base64Key: "GCOyjmHQ2VQXvnwnVGmkAoiXhWThSn7t69rB4D/pgmw=")!

var CLIENT_DNS_2_1 = DNSServer(from: "94.140.14.14")!
var CLIENT_DNS_2_2 = DNSServer(from: "94.140.15.15")!

var ADDRESS_2_1 = IPAddressRange(from: "10.66.66.3/32")!
var ADDRESS_2_2 = IPAddressRange(from: "fd42:42:42::3/128")!



// YENİ CRED

var SERVER_PUBLIC_KEY_4 = PublicKey(base64Key: "m7A45suVWYIJpeu7Iu5GgWvTGg76L07ntCqvjT23HAo=")!

var ALLOWED_IPS_4_1 = IPAddressRange(from: "0.0.0.0/0")!
var ALLOWED_IPS_4_2 = IPAddressRange(from: "::/0")!

var SERVER_ENDPOINT_STRING_4 = "35.175.129.14:51820"
var SERVER_ENDPOINT_4 = Endpoint(from: SERVER_ENDPOINT_STRING)

var SERVER_PRESHARED_KEY_4 = PreSharedKey(base64Key: "D/1GP2mt3S/x6jMfHuNLMfH4A/oIdb8y7bDTTAvHQr4=")!

var SERVER_PRIVATE_KEY_4 = PrivateKey(base64Key: "zA4JA/vI4oqaRLK9mtE/PAnsMcot5x9QEVb9XM8lvHE=")!

var CLIENT_DNS_4_1 = DNSServer(from: "1.1.1.1")!
var CLIENT_DNS_4_2 = DNSServer(from: "1.0.0.1")!

var ADDRESS_4_1 = IPAddressRange(from: "10.3.2.116/32")!
var ADDRESS_4_2 = IPAddressRange(from: "fd00::3:2:10/128")!
>>>>>>> Stashed changes
