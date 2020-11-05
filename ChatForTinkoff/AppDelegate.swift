//
//  AppDelegate.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 13.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var switchLogs = SwitchLogs()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        switchLogs.forAppDelegate(from: "Not Running", to: "Inactive", method: "\(#function)")
 
        FirebaseApp.configure()
//        CoreDataStack.shared.enableObservers()

        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        switchLogs.forAppDelegate(from: "Active", to: "Inactive", method: "\(#function)")

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        switchLogs.forAppDelegate(from: "Inactive", to: "Background", method: "\(#function)")

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        switchLogs.forAppDelegate(from: "Background", to: "Inactive", method: "\(#function)")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        switchLogs.forAppDelegate(from: "Inactive", to: "Active", method: "\(#function)")
  
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        switchLogs.forAppDelegate2(method: "\(#function)")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
