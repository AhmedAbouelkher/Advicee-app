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
    func didRecive(_ manager: NotificationManager, userData: [String : Any])
}

final class NotificationManager: NSObject {
    /// Get `NotificationManager` instance to use.
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
    
    public func isNotificationServicesEnabled() -> Bool {
        return UserDefaults.standard.isNotificationServicesEnabled()
    }
    
    //MARK:- Notification -
    
    private struct Notification {
        let title: String
        let sound: UNNotificationSoundName?
    }
    
    private let notificaitonTitles: [Notification] = [
        Notification(title: "Advice of the day 🥰", sound: .init("swiftly-610.mp3")),
        Notification(title: "Your new advice is served 😃", sound: .init("closure-542.mp3")),
        Notification(title: "Here your are a bit of a new advice 🎉", sound: .init("eventually-590.mp3")),
        Notification(title: "Here me out 😜", sound: .init("juntos-607.mp3")),
        Notification(title: "Did you know? 🤔", sound: .init("piece-of-cake-611.mp3")),
    ]
    
    /// Returns a random advice notification message title & tone.
    /// - Returns: `Notification` object.
    private func getNotificationMessageTitle() -> Notification {
        return notificaitonTitles.randomElement()!
    }
    
    //MARK:- Fire Notification Methods
    
    /// Fires a notifiacation with a new advice.
    /// - Parameters:
    ///   - advice: The fetched advice object.
    ///   - title: Notification message title.
    public func fireNotifications(with advice: Advice) {
        guard self.isNotificationServicesEnabled() else {
            print("Notification services are offline")
            return
        }
        let notificationContent = UNMutableNotificationContent()
        let randomNotificationData = self.getNotificationMessageTitle()
        notificationContent.title = randomNotificationData.title
        notificationContent.body = advice.slip.advice
        if let tone = randomNotificationData.sound {
            notificationContent.sound = UNNotificationSound(named: tone)
        }
        
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
                self.delegate?.didRecive(self, userData: ["advice": advice.slip.advice])
            }
        }
    }
    
    /// Clears the app notification icon badges.
    public func clearBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.clearBadgesFromStorage()
    }
    
    /// Enables notification services.
    ///
    /// Must call in `main thread`
    public func enableNotificationServices(in rootVC: UIViewController) {
        UserDefaults.standard.changeNotificationAvailability(with: true)
        requestPermission(in: rootVC)
    }
    
    /// Disables notification services.
    public func disableNotificationServices() {
        UserDefaults.standard.changeNotificationAvailability(with: false)
    }
    
    
    //MARK:- Permission -
    
    /// Request notification permission
    /// - Parameter vc: The current working `UIViewController` to display the alert dialog.
    public func requestPermission(in vc: UIViewController) {
        assert(self.userNotifications != nil)
        
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotifications.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    print("User has authorized notification permission")
                } else if  settings.authorizationStatus == .denied {
                    UserDefaults.standard.changeNotificationAvailability(with: false)
                    self.showAlert(in: vc)
                } else {
                    self.userNotifications.requestAuthorization(options: authOptions) { (enabled, error) in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        if !enabled {
                            DispatchQueue.main.async {
                                self.showAlert(in: vc)
                            }
                        }
                        UserDefaults.standard.changeNotificationAvailability(with: enabled)
                    }
                }
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
        in rootVC: UIViewController,
        with title: String? = nil,
        content: String,
        completion: @escaping () -> Void
    ) {
        
        let alertDialogVC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        
        alertDialogVC.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            completion()
        }))
        
        alertDialogVC.addAction(UIAlertAction(title: "Don't ask again", style: .destructive, handler: { _ in
            UserDefaults.standard.showPermissionAlert = false
        }))
        
        alertDialogVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        rootVC.present(alertDialogVC, animated: true)
        
    }
    
    /// Showas `showNotificationsPermissionAlert` if the user denied notifications.
    /// - Parameter vc: The current view controlelr.
    private func showAlert(in vc: UIViewController) {
        if !UserDefaults.standard.showPermissionAlert { return }
        showNotificationsPermissionAlert(
            in: vc,
            with: "Enable Notifiactions 😢",
            content: "To help us deliver awesome content and to use all the app potentials, we highly recommend enabling Notification 🥰."
        ) {
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!, options:[:], completionHandler: nil
            )
        }
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let advice = response.notification.request.content.body
        self.delegate?.didRecive(self, userData: ["advice": advice])
        self.clearBadges()
        completionHandler()
    }
}


fileprivate extension UserDefaults {
    
    //MARK:- Permission Alert Dialog -
    
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
    
    //MARK:- Enabling/Disabling Notification services -
    
    /// Changes the storered value with which the app will choose to push local notification or not.
    /// - Parameter available: Whether or not to make the push notification service live.
    func changeNotificationAvailability(with available: Bool) {
        //        let oldValue = self.value(forKey: "enableNotificationService") as? Bool
        //        if available == oldValue {
        //            fatalError("New `NotificationAvailability` value is the same as the old one")
        //        }
        self.setValue(available, forKey: "enableNotificationService")
    }
    
    /// Returnes the stores value with which the app will choose to push local notification or not.
    /// - Returns: The stored value of push notification service availablility.
    func isNotificationServicesEnabled() -> Bool {
        guard let enabled = self.value(forKey: "enableNotificationService") as? Bool else {
            return true
        }
        return enabled
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
    
    //MARK:- Background fetching date storage -
    
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

