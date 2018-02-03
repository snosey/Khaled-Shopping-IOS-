//
//  AppDelegate.swift
//  Shopping
//
//  Created by Naggar on 11/10/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import Google
import FirebaseInstanceID
import IQKeyboardManagerSwift
import UserNotifications
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    // For Google SignIn
    var kClient = "489967054898-dnnvlnmuvh39813tdvb2u5iesv50oht9.apps.googleusercontent.com"

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        return GIDSignIn.sharedInstance().handle(url , sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        
        // Check if user is logged into our app or not
        // If user Logged to System
        if UserStatus.login {
            
            let homeTabBar = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar) as! UITabBarController
            
            var counter: Int = 0
            WebServices.getInbox(completion: { (success, messages) in
                if success {
                    
                    for eachMessage in messages! {
                        counter += Int(eachMessage.unReed)!
                    }
                    
                    if counter != 0 {
                        homeTabBar.viewControllers![3].tabBarItem.badgeValue = "\(counter)"
                    }
                }
            })
            
            window?.rootViewController = homeTabBar
            window?.makeKeyAndVisible()
            
        }
        
        // Handle FACEBOOK SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Handle GOOGLE SDK
        GIDSignIn.sharedInstance().clientID = kClient
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        
        
        // Handle IQKeyboardManagerSwift
        IQKeyboardManager.sharedManager().enable = true

        
        
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        if let data = userInfo["data"] as? String {
            
            print("Message ID: \(data)")
            
            let json = JSON(parseJSON: data)
            
            print(json["message"].string ?? "NIL MESSAGE")
            
            let payloadData = json["payload"]["data"].string!
            
            let payloadKind = json["payload"]["kind"].string!
            
            print(payloadData)
            print(payloadKind)
            
            let content = UNMutableNotificationContent()
            content.title = json["title"].string ?? ""
            // content.subtitle =
            content.body = json["message"].string ?? ""
            content.badge = 0 // Doesn’t Work for me :"D
            content.sound = UNNotificationSound.default()
            
            content.userInfo = ["kind" : payloadKind , "data" : payloadData]
            
            // Push Notification after 5 seconds from UIBarButtonItem Was Clicked
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1 , repeats: false)
            
            // REQUEST
            let request = UNNotificationRequest(identifier: payloadKind, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if error == nil {
                    // DONE
                } else {
                    // ERROR
                }
            }
            
            
            
            
            
        }

        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        
        if let data = userInfo["data"] as? String {
            
            print("Message ID: \(data)")
            
            let json = JSON(parseJSON: data)
            
            print(json["message"].string ?? "NIL MESSAGE")
            
            let payloadData = json["payload"]["data"].string!
            
            let payloadKind = json["payload"]["kind"].string!
            
            print(payloadData)
            print(payloadKind)
            
            let content = UNMutableNotificationContent()
            content.title = json["title"].string ?? ""
            // content.subtitle =
            content.body = json["message"].string ?? ""
            content.badge = 0 // Doesn’t Work for me :"D
            content.sound = UNNotificationSound.default()
            
            content.userInfo = ["kind" : payloadKind , "data" : payloadData]
            
            // Push Notification after 5 seconds from UIBarButtonItem Was Clicked
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1 , repeats: false)
            
            // REQUEST
            let request = UNNotificationRequest(identifier: payloadKind, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if error == nil {
                    // DONE
                } else {
                    // ERROR
                }
            }

            
            
            
            
        }
  
        
   
        
        
  
  
        
        /*
        
        [
            AnyHashable("data"):
                {
                    "title": "SSSSSSS",
                    "message": "SSSSSSS",
                    "timestamp": "TIME"

            },
         
            AnyHashable("aps"):
                {
                    "content-available" = 1;
            },

            AnyHashable("gcm.message_id"): ""
        ]

         
        */
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
        
        
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
        
        guard UserStatus.login else {   return }

        
        if let accessToken = InstanceID.instanceID().token() {
            
            WebServices.clientRegId(regID: accessToken, { (success) in
                if success {
                    print("DONE")
                } else {
                    print("ERROR")
                    
                }
            })
            
            
        }
        
        
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        

        
        
        // Change this to your preferred presentation option
        completionHandler([.alert , .badge , .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        if userInfo[AnyHashable("kind")] as? String == "Love" {
            
            // let homeTabBar = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar) as! UITabBarController

            let loveProductNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.productProfileNav) as! UINavigationController
            
            if let productDetailsVC = loveProductNav.viewControllers[0] as? ProductProfileVC {
                productDetailsVC.productID = userInfo[AnyHashable("data")] as! String
            
                WebServices.getProductDetails("", userInfo[AnyHashable("data")] as! String, completion: { (success, productDetail) in
                    
                    productDetailsVC.client_id_of_owner = productDetail!.id_client
                    
                    
                    self.window?.currentViewController()?.present(loveProductNav, animated: false, completion: nil)

                })
                

            }
            

            
            
            
        } else if userInfo[AnyHashable("kind")] as? String == "Review" {
            
            let reviewNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ReviewNav) as! UINavigationController
            
            if let reviewVC = reviewNav.viewControllers[0] as? ReviewVC {
                
                reviewVC.idClient = userInfo[AnyHashable("data")] as! String
                
                
                window?.currentViewController()?.present(reviewNav, animated: false, completion: nil)
                
            }
            
            
        } else if userInfo[AnyHashable("kind")] as? String == "follow" {
            
            let reviewNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ClientProfileNav) as! UINavigationController
            
            if let clientVC = reviewNav.viewControllers[0] as? ClientProfileVC {
                
                clientVC.productOwnerID = userInfo[AnyHashable("data")] as! String
                
                
                window?.currentViewController()?.present(reviewNav, animated: false, completion: nil)
                
            }
            
            
        } else if userInfo[AnyHashable("kind")] as? String == "message" {
            
            // print(userInfo[AnyHashable("data")])
            let str = userInfo[AnyHashable("data")] as! String
            var clientID = ""
            var productID = ""
            var flag = true
            
            for index in str {
                if index != "|" && flag {
                    clientID = "\(clientID)\(index)"
                } else {
                    
                    if flag { flag = false ; continue }
                    
                    productID = "\(productID)\(index)"
                    
                }
            }

            let messageNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.MessagesNav) as! UINavigationController
            
            if let clientVC = messageNav.viewControllers[0] as? ClientChatVC {
                
                WebServices.getProductDetails("", productID, completion: { (success, productDetails) in
                    if success {
                        clientVC.idClient = clientID
                        clientVC.productID = productID
                        clientVC.productImage = productDetails!.img1
                        clientVC.ProfileTitle = productDetails!.title
                        
                        self.window?.currentViewController()?.present(messageNav, animated: false, completion: nil)

                    } else {
                        
                    }
                })
            }
        }
        
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        guard UserStatus.login else { return }
        
        WebServices.clientRegId(regID: fcmToken) { (success) in
            if success {
                print("DONE")
                
                
                
            } else {
                print("ERROR")
                
            }
        }
        
        
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
        
      
    }
    
    
    // [END ios_10_data_message]
}
