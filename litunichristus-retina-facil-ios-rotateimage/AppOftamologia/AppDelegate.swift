//
//  AppDelegate.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 21/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import UIKit
import Firebase

var currentPatient : Patient = Patient()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        firebaseRef = Database.database().reference()

        setupAppearance()

        AuthManager.checkIfNeedsLogin(completion: { (needsLogin) in
            if needsLogin {
                _ = self.startAppWithControllerID(id: "NavigationLogin")
            }
        })

        return true
    }

    func setupAppearance(){
        UIBarButtonItem.appearance().tintColor = appWhiteColor
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).textColor = UIColor.white

        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white
            ]
            //UINavigationBar.appearance().setBackgroundImage(appMainColor.as1ptImage(), for: .default)
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }

        UINavigationBar.appearance().shadowImage = UIImage()

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]


        UINavigationBar.appearance().tintColor = appWhiteColor
        UINavigationBar.appearance().backgroundColor = appMainColor
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func startAppWithControllerID(id: String) -> UIViewController {

        let overlayView = UIView()
        overlayView.frame = self.window!.rootViewController!.view.bounds
        overlayView.backgroundColor = appMainColor

        let storyboard = self.window!.rootViewController!.storyboard
        let viewController = storyboard?.instantiateViewController(withIdentifier: id)
        viewController!.modalTransitionStyle = .crossDissolve
        viewController!.modalPresentationStyle = .fullScreen

        self.window?.makeKeyAndVisible()
        self.window?.addSubview(overlayView)

        self.window!.rootViewController?.present(viewController!, animated: false, completion: { () -> Void in

            UIView.animate(withDuration: 0.625, animations: { () -> Void in
                overlayView.alpha = 0
            }, completion: { (_) -> Void in
                overlayView.removeFromSuperview()
            })

        })
        return viewController!
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

