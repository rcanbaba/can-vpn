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
        
        
        os_log(.info,"BABACAN - options dict: %{public}@", options!)
        
        // NS Interface
        let rawInterfacePrivateKey = options?["interfacePrivateKey"] as! String
        let rawInterfaceMTU = options?["interfaceMTU"] as! Int
        let rawInterfaceAddress = options?["interfaceAddress"] as! [String]
        let rawInterfaceDNS = options?["interfaceDNS"] as! [String]
        
        // NS Peer
        let rawPeerPresharedKey = options?["peerPresharedKey"] as! String
        let rawPeerPublicKey = options?["peerPublicKey"] as! String
        let rawPeerAllowedIPs = options?["peerAllowedIPs"] as! [String]
        let rawPeerEndpoint = options?["peerEndpoint"] as! String

        os_log(.info,"BABACAN - NS completed")
        
        let interfacePrivateKey = PrivateKey(base64Key: rawInterfacePrivateKey)!
        let interfaceAddress = rawInterfaceAddress.compactMap {IPAddressRange(from: $0)}
        let interfaceDNS = rawInterfaceDNS.compactMap {DNSServer(from: $0)}
        let interfaceMTU = UInt16(rawInterfaceMTU)
        
        let peerPublicKey = PublicKey(base64Key: rawPeerPublicKey)!
        let peerPresharedKey = PreSharedKey(base64Key: rawPeerPresharedKey)!
        let peerAllowedIPs = rawPeerAllowedIPs.compactMap {IPAddressRange(from: $0)}
        let peerEndpoint = Endpoint(from: rawPeerEndpoint)
        
        os_log(.info,"BABACAN - All parsed setted")
        
        var interfaceConfiguration = InterfaceConfiguration(privateKey: interfacePrivateKey)
        interfaceConfiguration.dns = interfaceDNS
        interfaceConfiguration.addresses = interfaceAddress
        interfaceConfiguration.mtu = interfaceMTU
        
        var peerConfiguration = PeerConfiguration(publicKey: peerPublicKey)
        peerConfiguration.preSharedKey = peerPresharedKey
        peerConfiguration.allowedIPs = peerAllowedIPs
        peerConfiguration.endpoint = peerEndpoint
        
        let tunnelConfig = TunnelConfiguration(name: "tunnelConfig",
                                               interface: interfaceConfiguration,
                                               peers: [peerConfiguration])
        
        // Finally, start WireGuard and call `completionHandler` when ready.
        wireguard?.start(tunnelConfiguration: tunnelConfig, completionHandler: { error in
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
