//
//  Config.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import Foundation
import WireGuardKit

// The client's WireGuard private key.
let CLIENT_PRIVATE_KEY = PrivateKey(base64Key: "OBSp74gbmSHtZjpD7q9Kzldwz8HGR5xZwZM4mClcV0Q=")!

// The client's virtual IP address for WireGuard.
let CLIENT_IP = IPAddressRange(from: "10.66.66.3")!


// The DNS server to use for the client.
let CLIENT_DNS = DNSServer(from: "1.1.1.1")!

// The server's WireGuard public key.
let SERVER_PUBLIC_KEY = PublicKey(base64Key: "4mr2idcjAD/1ql6DbH76gnrcZJCyBKGk/zoZ2tv4URY=")!

// The server's IP address and port, such as "1.2.3.4:51820" or similar.
let SERVER_ENDPOINT_STRING = "15.237.93.242:57630"

// The server's endpoint, generated from `SERVER_ENDPOINT_STRING`.
let SERVER_ENDPOINT = Endpoint(from: SERVER_ENDPOINT_STRING)
