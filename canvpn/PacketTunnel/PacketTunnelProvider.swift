//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Can Babaoğlu on 11.04.2023.
//

import NetworkExtension
import WireGuardKit
import os.log

import os.log

struct Log {
    static var general = OSLog(subsystem: "com.wg.Can.ilovevpn.nextension", category: "general")
}


/* OLD CONFIG  [62, 92] arası burda
 
 let SERVER_PUBLIC_KEY1 = PublicKey(base64Key: "upS8vveb1QW/rr1B9Zdu59tw5O4XWrpndX/Kpg6pGWw=")!

 var peerConfig = PeerConfiguration(publicKey: SERVER_PUBLIC_KEY1)

 peerConfig.allowedIPs = [IPAddressRange(from: "0.0.0.0/0")!, IPAddressRange(from: "::/0")!]
 peerConfig.endpoint = SERVER_ENDPOINT
 peerConfig.preSharedKey = PreSharedKey(base64Key: "e3qTVsUa8rlotL8xaw+512Wr74PWO35QzYLI+bWzd1M=")
 

 // Construct the configuration for the client.
 
 let CLIENT_PRIVATE_KEY1 = PrivateKey(base64Key: "GCOyjmHQ2VQXvnwnVGmkAoiXhWThSn7t69rB4D/pgmw=")!
 var interfaceConfig = InterfaceConfiguration(privateKey: CLIENT_PRIVATE_KEY1)
 
 
 
 let CLIENT_DNS1 = DNSServer(from: "94.140.14.14")!
 let CLIENT_DNS2 = DNSServer(from: "94.140.15.15")!
 interfaceConfig.dns = [CLIENT_DNS1, CLIENT_DNS2]
 
 

 let CLIENT_IP1 = IPAddressRange(from: "10.66.66.3/32")!
 let CLIENT_IP2 = IPAddressRange(from: "fd42:42:42::3/128")!
 interfaceConfig.addresses = [CLIENT_IP1, CLIENT_IP2]
 
 

 // Construct a new `TunnelConfiguration` using the configuration
 // instances.
 let tunnelConfig = TunnelConfiguration(name: "Wireguard2323", interface: interfaceConfig, peers: [peerConfig])
 
 
 
 
 */



class PacketTunnelProvider: NEPacketTunnelProvider {
    private var wireguard: WireGuardAdapter? = nil

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Construct a new WireGuard instance with this `PacketTunnelProvider`.
        wireguard = WireGuardAdapter(with: self, logHandler: { level, log in print(log) })
<<<<<<< Updated upstream

        
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
=======
        
       // tunnelConfiguration123456
        
        
//        guard let tunnelProviderProtocol = self.protocolConfiguration as? NETunnelProviderProtocol,
//              let tunnelConf = tunnelProviderProtocol.asTunnelConfiguration()
//        else {
//            return
//        }
//
        
        let a = (options?.first?.value) as? String
        
        
        let deneme = Endpoint(from: a ?? "yarak")
        
        // Construct the configuration for the server.*
        var peerConfig = PeerConfiguration(publicKey: SERVER_PUBLIC_KEY_4)
        peerConfig.allowedIPs = [ALLOWED_IPS_4_1, ALLOWED_IPS_4_2]
        peerConfig.endpoint = SERVER_ENDPOINT_4
        peerConfig.preSharedKey = SERVER_PRESHARED_KEY_4
        
        // Construct the configuration for the client.
        var interfaceConfig = InterfaceConfiguration(privateKey: SERVER_PRIVATE_KEY_4)
        interfaceConfig.dns = [CLIENT_DNS_4_1, CLIENT_DNS_4_2]
        interfaceConfig.addresses = [ADDRESS_4_1, ADDRESS_4_2]
        
        // Construct a new `TunnelConfiguration` using the configuration
        
        
        
        // instances.
        let tunnelConfig = TunnelConfiguration(name: "ilovevpn", interface: interfaceConfig, peers: [peerConfig])
        
        // Finally, start WireGuard and call `completionHandler` when ready.
        wireguard?.start(tunnelConfiguration: tunnelConfig, completionHandler: { error in
            os_log(.info,"canVPn, startTunnel comp handler")
            
            
>>>>>>> Stashed changes
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
