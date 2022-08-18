//
//  AppDelegate.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // .configure() - настраиваем общий экземпляр FirebaseApp
        FirebaseApp.configure()
        // .firestore() - Создает, кэширует и возвращает «Firestore», используя «FirebaseApp» по умолчанию. Каждый последующий вызов возвращает один и тот же объект «Firestore».
        let db = Firestore.firestore()
        print(db)
        
        // IQKeyboardManager - При разработке приложений для iOS мы часто сталкиваемся с проблемами, когда клавиатура iPhone скользит вверх и покрывает UITextField/UITextView. IQKeyboardManager позволяет предотвратить эту проблему скольжения клавиатуры вверх и покрытия UITextField/UITextView без необходимости писать какой-либо код или делать какие-либо дополнительные настройки.
        
        // Включить/выключить управление расстоянием между клавиатурой и текстовым полем. По умолчанию — YES (включено).
        IQKeyboardManager.shared.enable = true
        // Автоматическое добавление функциональности IQToolbar. По умолчанию — YES (включено).
        IQKeyboardManager.shared.enableAutoToolbar = false
        // Убирает клавиатуру при касании за пределами UITextField/View. По умолчанию — NO (выключено).
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
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
