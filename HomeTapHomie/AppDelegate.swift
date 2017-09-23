//
//  AppDelegate.swift
//  HomeTapHomie
//
//  Created by juan esteban chaparro on 15/07/17.
//  Copyright © 2017 Tres Astronautas. All rights reserved.
//
import UIKit
import MBProgressHUD
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import GoogleMaps
import GoogleSignIn
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        // Configurar Firebase
        FirebaseApp.configure()
        
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // Configurar Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        
        // Configurar Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Configuracion de GMaps
        // GMSServices.provideAPIKey("AIzaSyAM2e7EaL92l9aMC9u1oFVhbwq5ygC4_qM")
        
        // Private configurations
        // ...
    
        GMSServices.provideAPIKey("AIzaSyCOLqvkS20vF-DHdzSZE0mBJC7H2knnwvQ")
        //let tabBar: UITabBarController = self.window?.rootViewController as! UITabBarController
        //tabBar.selectedIndex = 2
        // Notifications configuration
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
        application.applicationIconBadgeNumber = 0
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled_by_fb = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        let handled_by_google = GIDSignIn.sharedInstance().handle(url,
                                                                  sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                  annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled_by_fb || handled_by_google
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
        
        let defaults = UserDefaults.standard
        if let id = K.User.OnServiceId {
            defaults.set("OnServiceId", forKey:id)
        }
        defaults.synchronize()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let defaults = UserDefaults.standard
        let defaultValue = ["OnServiceId" : " "]
        defaults.register(defaults: defaultValue)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo.description)
        K.User.reloadClient()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
         print("2")
         print(userInfo.description)
        K.User.reloadClient()
        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    
}

