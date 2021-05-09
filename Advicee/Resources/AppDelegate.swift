//
//  AppDelegate.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit
import BackgroundTasks
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ColorsManager.shared.updateColor()
        let backgroundFetchDefaultDate = NotificationManager.shared.backgroundFetchDefaultDate
        let backgroundFetchDefaultTimeInterval = backgroundFetchDefaultDate?.getTimeInterval() ?? 1800.0
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(backgroundFetchDefaultTimeInterval)
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationManager.shared.clearBadges()
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AF.request("https://api.adviceslip.com/advice").responseDecodable(of: Advice.self) { response in
            switch response.result {
            case .success(let resp):
                NotificationManager.shared.fireNotifications(with: resp, show: "Advice of the day")
                print(resp.slip.advice)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        completionHandler(.newData)
    }
    
    
    //MARK:- Disabled -
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.refresh")
        // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        print(request.earliestBeginDate!)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task
        scheduleAppRefresh()
        
        print("Info")
        
        // Provide an expiration handler for the background task
        // that cancels the operation
        task.expirationHandler = {
            print("Canceled")
        }
        
        // Inform the system that the background task is complete
        // when the operation completes
        task.setTaskCompleted(success: true)
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


//if #available(iOS 13.0, *) {
//    // MARK: Registering Launch Handlers for Tasks
//    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.refresh", using: nil) { task in
//        // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
//        self.handleAppRefresh(task: task as! BGAppRefreshTask)
//    }
//}


