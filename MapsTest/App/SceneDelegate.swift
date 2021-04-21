//
//  SceneDelegate.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 30.03.2021.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var blind: UIView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        getNotificationAllow()
        
        let controller: UIViewController
        let loginKey = "isLogin"
        if UserDefaults.standard.bool(forKey: loginKey) {
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MenuViewController.self)
        } else {
            controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(AuthViewController.self)
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: controller)
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func getNotificationAllow() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
        }
    }
    
    func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Карты"
        content.subtitle = "Нуждаются в тебе"
        content.body = "Без тебя на них никто не смотрит"
        content.badge = 1
        return content
    }
    
    func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 30*60, repeats: false)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let blind = blind else { return }
        blind.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        guard let window = window else { return }
        let rect = CGRect(x: 0.0, y: 0.0, width: window.bounds.width, height: window.bounds.height)
        blind = UIView(frame: rect)
        guard let blind = blind else { return }
        blind.backgroundColor = .gray
        window.rootViewController?.view.addSubview(blind)
        
        self.sendNotificationRequest(content: self.makeNotificationContent(), trigger: self.makeIntervalNotificationTrigger())
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

