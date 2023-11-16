//
//  AppDelegate.swift
//  TodoList
//
//  Created by Nguyen Van Son on 08/11/2023.
//

import UIKit
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            _ = try Realm()
        } catch  {
            print("Error initial Realm")
        }
        return true
    }
}

