//
//  PushNotificationHelper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//


import UIKit
import UserNotifications
import SwiftyJSON
import FirebaseAnalytics

enum PushNotificationType: String {
    case silent = "silent"
    case firstSubscription = "first_subscription"
    case reactivateSubscription = "reactivate_subscription"
}

class PushNotificationBase {
    var badgeCount: Int?
    var titleText: String?
    var buttonText: String?
    var bodyText: String?
    var notifType: PushNotificationType?
    var pictureUrl: String?
    
    init() { }
    
    init(json: JSON) {
        self.badgeCount = json["badge_count"].intValue
        self.titleText = json["title_text"].stringValue
        self.bodyText = json["body_text"].stringValue
        self.buttonText = json["button_text"].stringValue
        self.notifType = PushNotificationType(rawValue: json["type"].stringValue)
    }
}

class SilentPushNotification: PushNotificationBase { }

class ConversationNotification: PushNotificationBase {
    var userId: String?
    var conversationId: String?
    var userName: String?
    
    override init() {
        super.init()
    }
    
    override init(json: JSON) {
        self.userId = json["user_id"].stringValue
        self.conversationId = json["conversation_id"].stringValue
        self.userName = json["user_name"].stringValue
        super.init(json: json)
    }
}

class PushNotificationHelper {
    
    private static var retryFCMToken = true
    
    public static func takePushNotificationPermission(compHandler: @escaping (Bool, Error?) -> ()) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { result, error in
                compHandler(result, error)
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public static func getPushNotificationPermissionStatus (compHandler: @escaping (UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            compHandler(permission.authorizationStatus)
        })
    }
    
    public static func setAPNSToken(token: Data?) {
        guard let tokenString = token?.map({ String(format: "%02.2hhx", $0) }).joined() else { return }
        
        var registerAPNSRequest = RegisterAPNSRequest()
        registerAPNSRequest.setParams(token: tokenString)
        
        let networkService = DefaultNetworkService()
        networkService.request(registerAPNSRequest) { result in
            switch result {
            case .success(let response):
                print("💙: registerAPNSRequest - success - \(response.success)")
            case .failure(let error):
                print("💙: registerAPNSRequest - failure")
                Analytics.logEvent("006-API-registerAPNSRequest", parameters: ["error" : "happened"])
            }
        }

    }
    
    // bu sadece gösterildiğinde yapılacak şey
    public static func handleWillPresentCompletionHandler(dict: [AnyHashable: Any], completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let json = JSON(dict)
        guard let type = PushNotificationType(rawValue: json["type"].stringValue) else {
            completionHandler([.alert, .sound])
            return
        }
    }
    
    // app içindeyken taplersem de buraya düşüyor
    public static func processDictionary(dict: [AnyHashable: Any]) {
        let json = JSON(dict)
        
        guard let type = PushNotificationType(rawValue: json["type"].stringValue) else { return }
        
        switch type {
        case .silent:
            let silentPushNotification = SilentPushNotification(json: json)
            processNotification(notification: silentPushNotification)
        case .firstSubscription:
            processNotification(type: type)
        case .reactivateSubscription:
            processNotification(type: type)
        }
    }
    
    public static func processNotification(conversationId: String?) {
       
    }
    
    public static func processNotification(notification: SilentPushNotification) {
        //NO ACTIONS REQUIRED
    }
    
    public static func processNotification(type: PushNotificationType) {
        
    }
    
    public static func setFCMToken(token: String?) {
        guard let token = token else { return }
        
        dump(token)
        
        if KeyValueStorage.deviceId == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                setFCMToken(token: token)
            }
            return
        }
        
        if token == KeyValueStorage.pushNotificationFCMToken {
            return
        }

        var registerFCMRequest = RegisterFCMRequest()
        registerFCMRequest.setParams(token: token)
        
        let networkService = DefaultNetworkService()
        networkService.request(registerFCMRequest) { result in
            switch result {
            case .success(let response):
                if response.success {
                    print("💙: registerFCMRequest - success - true")
                    KeyValueStorage.pushNotificationFCMToken = token
                } else {
                    print("💙: registerFCMRequest - success - false")
                    if !retryFCMToken {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        retryFCMToken = false
                        setFCMToken(token: token)
                    }
                }
            case .failure(let error):
                print("💙: registerFCMRequest - failure")
                if !retryFCMToken {
                    return
                }
                Analytics.logEvent("007-API-registerFCMRequest", parameters: ["error" : "happened"])
                DispatchQueue.main.async {
                    retryFCMToken = false
                    setFCMToken(token: token)
                }
            }
        }
    }

}
