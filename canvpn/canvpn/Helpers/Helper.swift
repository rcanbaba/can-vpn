//
//  Helper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.12.2022.
//

enum ConnectionState {
    case initial
    case connect
    case connecting
    case connected
    case disconnecting
    case disconnected

}

extension ConnectionState {
    
    func getStateText() -> String {
        switch self {
        case .initial:
            return "connect"
        case .connect:
            return "connect"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        case .disconnecting:
            return "disconnecting"
        case .disconnected:
            return "disconnected"
        }
    }
    
    func getUserInteraction() -> Bool {
        switch self {
        case .initial, .connect, .connected, .disconnected:
            return true
        case .connecting, .disconnecting:
            return false
        }
    }
    
}
