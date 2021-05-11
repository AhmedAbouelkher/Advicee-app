//
//  NotificationManager.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

protocol NotificationManagerDelegate: AnyObject {
    /// The method is triggerd when the manager sends a new advice and start processing its notification message.
    /// - Parameters:
    ///   - manager: The current used notiication manager.
    ///   - userData: The data which the manager decided to send  to the current delegate owner.
    func didRecive(_ manager: NotificationManager, userData: [String:Any?]?)
}

final class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    private var userNotifications: UNUserNotificationCenter!
    
    private override init() {
        super.init()
        userNotifications = UNUserNotificationCenter.current()
        userNotifications.delegate = self
    }
    
    /// `NotificationManagerDelegate` which can be used to enteract with the current notification manager.
    public weak var delegate: NotificationManagerDelegate?
    
    /// The default date "aka: `TimeInterval`" at which the background advice fetch will fire.
    public var backgroundFetchDefaultDate: Date? {
        UserDefaults.backgroundFetchDefaultDate()
    }
    
    /// Asign the default time "aka: `TimeInterval`" at which the background advice fetch will fire.
    /// - Parameter date: The given date from `UIDatePicker`.
    public func setBackgroundFetchDefaultDate(with date: Date) {
        UserDefaults.saveBackgroundFetchDefaultDate(with: date)
    }
    
    
    //MARK:- Fire Notification Methods
    
    /// Fires a notifiacation with a new advice.
    /// - Parameters:
    ///   - advice: The fetched advice object.
    ///   - title: Notification message title.
    public func fireNotifications(with advice: Advice, show title: String? = nil) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title ?? ""
        notificationContent.body = advice.slip.advice
        notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName("notification_sound.wav"))
        
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
    
    /// Clears the app notification icon badges
    public func clearBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.clearBadgesFromStorage()
    }
    
    
    //MARK:- Permission-
    
    /// Request notification permission
    /// - Parameter vc: The current working `UIViewController` to display the alert dialog.
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
    
    /// Show the Notification permission error alert to ask the user to go to `Settings` and allow push local notification.
    /// - Parameters:
    ///   - vc: The current working `UIViewController` to display the alert dialog.
    ///   - title: Alert dialog title.
    ///   - content: Alert dialog conent.
    ///   - completion: The completion block which will be called when the user chooses to go to `Settings`
    private func showNotificationsPermissionAlert(
        in vc: UIViewController,
        with title: String? = nil,
        content: String,
        completion: @escaping () -> Void
    ) {
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

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.clearBadges()
        completionHandler()
    }
}


private extension UserDefaults {
    
    //MARK:- Permission Alert Dialog-
    
    /// Show the user an alert dialog to allow him to go to `setting` and allow notification in case of refusing to give the app the permission at first.
    ///
    /// Can be used as: `Set` & `Get`
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
    
    /// Retunes the correct `Next badge number` which will be displayed on the app icon.
    /// - Returns: Next app notification badge number
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
    
    //MARK:- Background fetching date storage-
    
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

