//
//  AppDelegate.swift
//  TFSNews
//
//  Created by SHREDDING on 04.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let apiManager = ApiManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
//        if let keys = AppDelegate.apiManager.userDefaults.object(forKey: "keysImg") as? [String]{
//            for i in keys{
//                let data = AppDelegate.apiManager.userDefaults.object(forKey: i) as? Data
//                
//                AppDelegate.apiManager.imageCache.setObject(UIImage(data: data!)!, forKey: i as NSString)
//            }
//        }
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
//        for i in AppDelegate.apiManager.keysImages{
//            AppDelegate.apiManager.userDefaults.set((AppDelegate.apiManager.imageCache.object(forKey: (i as? NSString)!))!.pngData(), forKey: i)
//        }
//        
//        AppDelegate.apiManager.userDefaults.set([AppDelegate.apiManager.keysImages], forKey: "keysImg")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

