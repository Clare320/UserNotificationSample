//
//  ViewController.swift
//  UserNotificationSample
//
//  Created by Kede on 2019/1/8.
//  Copyright © 2019 Clare. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    @IBAction func createFirstLoaclNotification(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "这是一条本地推送"
        content.body = "使用最新的推送框架可以让推送变得更有趣"
        // assign the category --> 未生效 
        content.categoryIdentifier = "Sample"
        content.sound = UNNotificationSound.default
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "AlertSound.wav"))
        content.badge = 10
        
        // --> timeInterval是秒为单位，设置repeats为true时，timeInterval需要设置超过60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Local001", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("add local001")
            }
        }
       
    }
}

