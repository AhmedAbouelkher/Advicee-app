//
//  NotificationManager.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

protocol NotificationManagerDelegate: AnyObject {
    func didRecive(_ manager: NotificationManager, userData: [String:Any?]?)
}

final class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    private var userNotifications: UNUserNotificationCenter!
    
    public weak var delegate: NotificationManagerDelegate?
    
    private override init() {
        super.init()
        userNotifications = UNUserNotificationCenter.current()
        userNotifications.delegate = self
    }
    
//    public var backgroundFetchDefaultTimeInterval: TimeInterval {
//        UserDefaults.backgroundFetchDefaultTimeInterval()
//    }
//
//    public func setBackgroundFetchDefaultTimeInterval(with interval: TimeInterval) {
//        UserDefaults.saveBackgroundFetchDefaultTimeInterval(with: interval)
//    }
    
    public var backgroundFetchDefaultDate: Date? {
        UserDefaults.backgroundFetchDefaultDate()
    }
    
    public func setBackgroundFetchDefaultDate(with date: Date) {
        UserDefaults.saveBackgroundFetchDefaultDate(with: date)
    }
    
    
    //MARK:- Fire Notification Methods
    
    public func fireNotifications(with advice: Advice, show title: String? = nil) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title ?? ""
        notificationContent.body = advice.slip.advice
        notificationContent.sound = .default
        
        notificationContent.badge = UserDefaults.getCurrentBadgesNumber()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let requset = UNNotificationRequest(
            identifier: String(advice.slip.id),
            content: notificationContent,
            trigger: trigger
        )
        
        userNotifications.add(requset) { error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.delegate?.didRecive(self, userData: ["advice": advice])
                
            }
        }
    }
    
    public func clearBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.clearBadgesFromStorage()
    }
    
    
    //MARK:- Permission
    public func requestPermission(in vc: UIViewController) {
        assert(self.userNotifications != nil)
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        userNotifications.requestAuthorization(options: authOptions) { (success, error) in
            guard success, error == nil else {
                if UserDefaults.standard.showPermissionAlert {
                    self.showNotificationsPermissionAlert(in: vc, with: "Notifiactions", content: error!.localizedDescription) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options:[:], completionHandler: nil)
                    }
                }
                return
            }
        }
    }
    
    
    //MARK:- Alerts -
    
    private func showNotificationsPermissionAlert(in vc: UIViewController, with title: String? = nil, content: String, completion: @escaping () -> Void) {
        let vc = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        
        vc.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            completion()
        }))
        
        vc.addAction(UIAlertAction(title: "Don't ask again", style: .default, handler: { _ in
            UserDefaults.standard.showPermissionAlert = false
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        vc.present(vc, animated: true)
    }
}

/*
 
 @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
 optional func application(_ application: UIApplication, didReceive notification: UILocalNotification)
 
 */


extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.clearBadges()
        completionHandler()
    }
}


private extension UserDefaults {
    
    //MARK:- Permission Alert Dialog-
    var showPermissionAlert: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showPermissionAlert")
        }
        get {
            let show = UserDefaults.standard.value(forKey: "showPermissionAlert") as? Bool
            return show ?? true
        }
    }
    
    //MARK:- Notifications Badges-
    static func getCurrentBadgesNumber() -> NSNumber {
        var currentNotifications: Int {
            guard let num = UserDefaults.standard.value(forKey: "getCurrentBadgesNumber") as? Int else {
                return 0
            }
            return num
        }
        let newNum = currentNotifications + 1
        UserDefaults.standard.setValue(newNum, forKey: "getCurrentBadgesNumber")
        return NSNumber(value: newNum)
    }
    
    static func clearBadgesFromStorage() {
        UserDefaults.standard.setValue(nil, forKey: "getCurrentBadgesNumber")
    }
    
//    static func saveBackgroundFetchDefaultTimeInterval(with timeInterval: TimeInterval) {
//        UserDefaults.standard.setValue(timeInterval, forKey: "backgroundFetchDefaultTimeInterval")
//    }
    
//    static func backgroundFetchDefaultTimeInterval() -> TimeInterval {
//        guard let timeInterval = UserDefaults.standard.value(forKey:"backgroundFetchDefaultTimeInterval") as? TimeInterval else {
//            return 1800
//        }
//        return timeInterval
//    }
//
    static func saveBackgroundFetchDefaultDate(with date: Date) {
        UserDefaults.standard.setValue(date, forKey: "backgroundFetchDefaultTimeInterval")
    }
    
    static func backgroundFetchDefaultDate() -> Date? {
        guard let date = UserDefaults.standard.value(forKey:"backgroundFetchDefaultTimeInterval") as? Date else {
            return nil
        }
        return date
    }
    
}

