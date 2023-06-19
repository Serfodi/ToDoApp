//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 24.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        #if targetEnvironment(simulator)
        if let documentPacth = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("Task File Directory: \(documentPacth)")
        }
        #endif 
         
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


}

