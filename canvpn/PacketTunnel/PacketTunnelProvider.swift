//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Can Babaoğlu on 11.04.2023.
//

import NetworkExtension
import WireGuardKit
import os.log

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var wireguard: WireGuardAdapter? = nil

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Construct a new WireGuard instance with this `PacketTunnelProvider`.
        wireguard = WireGuardAdapter(with: self, logHandler: { level, log in print(log) })

        
        os_log(.info,"BABACAN123: %{public}@", SERVER_ENDPOINT_STRING_5)
        
        let a = options?.first?.key ?? "YEMEDİ"
        let b = options?.first?.value as? NSString
        
        let c = String(b ?? "YEMEDİ'")
        
        os_log(.info,"BABACAN456: %{public}@ -- %{public}@", a, c)
        
    //    os_log(.info,"BABACAN789: %{public}@ -- %{public}@", options!)
        
        
        var peerConfig2 = PeerConfiguration(publicKey: SERVER_PUBLIC_KEY_5)
        
        peerConfig2.allowedIPs = [ALLOWED_IPS_5_1, ALLOWED_IPS_5_2]
        peerConfig2.endpoint = SERVER_ENDPOINT_5
        peerConfig2.preSharedKey = SERVER_PRESHARED_KEY_5
        
        var interfaceConfig2 = InterfaceConfiguration(privateKey: SERVER_PRIVATE_KEY_5)
        
        interfaceConfig2.dns = [CLIENT_DNS_5_1, CLIENT_DNS_5_2]
        interfaceConfig2.addresses = [ADDRESS_5_1, ADDRESS_5_2]
        
        interfaceConfig2.mtu = 1280
        
        let tunnelConfig2 = TunnelConfiguration(name: "config12322", interface: interfaceConfig2, peers: [peerConfig2])
        
        // Finally, start WireGuard and call `completionHandler` when ready.
        wireguard?.start(tunnelConfiguration: tunnelConfig2, completionHandler: { error in
            os_log(.info,"BABACAN92929:")
            NSLog(error?.localizedDescription ?? "")
            completionHandler(error)
        })
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Stop WireGuard and call `completionHandler` when ready.
        wireguard?.stop(completionHandler: { error in
            NSLog(error?.localizedDescription ?? "")
            completionHandler()
        })
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}
