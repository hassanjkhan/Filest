//
//  AppDelegate.swift
//  Filest
//
//  Created by admin on 2020-03-15.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseDynamicLinks


@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    //Caches all information for profile and edit profile
    let profileCache = NSCache<NSString, UIImage>()
    let contactsCache = NSCache<NSString, UIImage>()
    
    //Stores dates for absence from calendarpopupview
    let firstSelectedDate = Date.init()
    let secondSelectedDate = Date.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        //authUI.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

