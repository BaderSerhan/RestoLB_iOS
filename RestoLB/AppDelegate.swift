//
//  AppDelegate.swift
//  RestoLB
//
//  Created by MacBook on 10/5/17.
//  Copyright © 2017 IdeationSoft. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    @nonobjc func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let token = InstanceID.instanceID().token(){
            print("Device Token: \(token)")
            preferences.set(token, forKey: "device_token")
            
            if preferences.integer(forKey: "useridkey") != 0{
                //send alamofire put request here to send device token
                let myurl = "\(URLs.userIDURL)\(preferences.integer(forKey: "useridkey"))"
                let parameters = ["device_token": token]
                Alamofire.request(myurl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .responseJSON(completionHandler: { response in
                        if let value = response.result.value {
                            let jsonContent = JSON(value)
                            print(jsonContent)
                        }
                    })
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        preferences.set(fcmToken, forKey: "device_token")
        if preferences.integer(forKey: "useridkey") != 0{
            //send alamofire put request here to send device token
            let myurl = "\(URLs.userIDURL)\(preferences.integer(forKey: "useridkey"))"
            let parameters = ["device_token": fcmToken]
            Alamofire.request(myurl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .responseJSON(completionHandler: { response in
                    if let value = response.result.value {
                        let jsonContent = JSON(value)
                        print(jsonContent)
                    }
                })
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //getOrderID
        //go to rating view of given order ID
        let data = JSON(userInfo)
        //print ("json \(data)")
        let order_id = data["order_id"].intValue
        //print(order_id)
        let type = data["type"].stringValue
        //print(type)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuView = storyboard.instantiateViewController(withIdentifier: "menuView") as! MenuViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: menuView)
        navigationController.navigationBar.tintColor = colors.RestoDefaultColor
        switch(type){
        case "review":
            let ratingView = storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
            ratingView.orderNum = order_id
            navigationController.pushViewController(ratingView, animated: true)
            window?.rootViewController = navigationController
        case "announcement":
            let annView = storyboard.instantiateViewController(withIdentifier: "announcementsView") as! AnnouncementsViewController
            navigationController.pushViewController(annView, animated: true)
            window?.rootViewController = navigationController
        case "stage":
            let orderHistoryView = storyboard.instantiateViewController(withIdentifier: "orderHistoryView") as! OrderHistoryViewController
            navigationController.pushViewController(orderHistoryView, animated: true)
            window?.rootViewController = navigationController
        default:
            return
        }
    }
}

