//
//  AppDelegate.swift
//  Todoey - Realm
//
//  Created by Artem Solovev on 06.08.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Realm - объект, представляющий базу данных Realm.
        // Configuration - Экземпляр конфигурации описывает различные параметры, используемые для создания экземпляра Realm.
        // defaultConfiguration - Конфигурация по умолчанию, используемая для создания Realms, когда никакая конфигурация не указана явно (например, Realm())
        // fileURL - Локальный URL-адрес файла Realm.
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            // инициализируем Realm
            _ = try Realm()
        } catch {
            print(error.localizedDescription)
        }
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

