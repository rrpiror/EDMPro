//
//  AppDelegate.swift
//  EDMPro
//
//  Created by Rob Prior on 21/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firstLoad: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9450980392, green: 0.3725490196, blue: 0.1490196078, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        loadUserDefaults()
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                if userDefaults.object(forKey: kCURRENTUSER) != nil {
                    
                    self.goToApp()
                    
                }
            }
        })
        
        return true

    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func loadUserDefaults() {
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.synchronize()
        }
    }
    
    //MARK: Helper Functions
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }


}

