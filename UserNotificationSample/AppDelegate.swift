//
//  AppDelegate.swift
//  UserNotificationSample
//
//  Created by Kede on 2019/1/8.
//  Copyright © 2019 Clare. All rights reserved.
//

import UIKit

import UserNotifications


/*
 banner至多显示两个按钮
 */


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        requestNotificationAuthorization()
        registerNotificationCategories()
        
        return true
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print(granted ? "allow notification" : "refuse notification")
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func registerNotificationCategories() {
        
        // 在长按推送通知显示出来自定义按钮
        let buyAction = UNNotificationAction(identifier: "BUY_ACTION", title: "Buy", options: .authenticationRequired)
        
        let sampleCategory = UNNotificationCategory(identifier: "Sample", actions: [buyAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([sampleCategory])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 处理app在前台时收到的通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("receive notification: \(notification.request.content.title) \r \(notification.request.content.body)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //NOTE: 不要做与通知不相关的事
        
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == UNNotificationDismissActionIdentifier {
            print("DismissActionIdentifier")
        } else if actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("DefaultActionIdentifier")
        }
        
        let content = response.notification.request.content
        if content.categoryIdentifier == "Sample" {
            if (response.actionIdentifier == "BUY_ACTION") {
                let alert = UIAlertController(title: "Tip", message: "You choose buy action!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        completionHandler()
    }
    
}

/**
 问题：点击notificationCategoryb对应的button，没有直接打开app
 */


extension AppDelegate {
    
    /*
     重装app，还原app，系统升级之后deviceToken都会发生变化
     一旦注册成功后只有deviceToken发生变化后app才会连接APNS，在app运行中deviceToken发生变化后也会通过didRegisterForRemoteNotificationsWithDeviceToken来告知
     */
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "failure"
        print("UUID--->\(uuid)")
        
        let tmpDeviceToken = NSData(data: deviceToken)
        let usedDeviceToken = tmpDeviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("after handle deviceToken--->\(usedDeviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotifications:\(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 处理remote notification
        
        print("remote notification userInfo:\(userInfo)")
        
        completionHandler(.newData)
    }
}
