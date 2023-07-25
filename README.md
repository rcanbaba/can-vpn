# vpn
## a vpn app

# IPSEC and WIREGUARD Supporting VPN app


WireGuardKit integration notes,

Xcode,

In build settings, click on the + and "ass user defined settings" 
then add PATH as key and ${PATH}:your-go-path as value

update your go version using brew, for go1.19.4 ->  ${PATH}:/opt/homebrew/opt/go@1.19/bin

also in the WireGuardKitGoBrigeiOS update de info directory it is not correct in the docs.

such as, 

/Users/canbaba/Library/Developer/Xcode/DerivedData/sonDenemeVpn-cevdvdcgetzidobpkebbbkldhfhr/SourcePackages/checkouts/wireguard-apple/Sources/WireGuardKitGo

(canvpn-cevdvdcgetzidobpkebbbkldhfhr) -> set your own path

---
WireGuardKit configuration notes, (***TunnelConfiguration***)

for PacketTunnel connection using WireGuardAdapter we should add,

PeerConfiguration with public key and,
- allowedIPs as an array
- endpoint
- preSharedKey (***obligatory***)

InterfaceConfiguration with private key and,
- DNSServers as an array
- Addresses (***IPAddressRange***)
- MTU

--- 
Additional Notes 

* for debugging NEPacketTunnelProvider use os_log.
* send options dictionary from NETunnelProviderManager to NEPacketTunnelProvider in startVPNTunnel method.
* in NETunnelProviderManager set your NETunnelProviderProtocol configuration providerBundleIdentifier as your PacketTunnel bundle id.
* 
--- 
* the app compatible with iPad and macOS
