//
//  SceneDelegate.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 30.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var blind: UIView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
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

