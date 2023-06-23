//
//  KeychainManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 17.05.2023.
//

import UIKit

class KeychainManager {

  public static let shared = KeychainManager()

  public func getDeviceIdentifierFromKeychain() -> String {
    if let idfv = KeychainWrapper.standard.string(forKey: "idfv") {
      return idfv
    } else {
      let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
      let status = KeychainWrapper.standard.set(idfv, forKey: "idfv")
      print(status)
      return idfv
    }
  }

  public func removeFromKeychain(key: String) {
    let status = KeychainWrapper.standard.removeObject(forKey: key)
    print(status)
  }

}
