//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Kede on 2019/1/9.
//  Copyright © 2019 Clare. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("UI Extension:\(notification.request.content.body)")
        self.label?.text = notification.request.content.body
    }

}

/*
 一个extension对应一个UNNotificationCategory，修改Info.plist中NSExtension->NSExtensionAttributes->UNNotificationExtensionCategory，与注册的categoryIdentifier保持一致
 */
