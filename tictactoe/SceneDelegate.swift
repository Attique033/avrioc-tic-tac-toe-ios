//
//  SceneDelegate.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import UIKit

@objc(SceneDelegate)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let authService: AuthServiceProtocol = AuthService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        if authService.getUserSession() != nil {
            let gameVC = GameViewController()
            navigationController.setViewControllers([gameVC], animated: false)
        } else {
            let loginVC = LoginViewController()
            navigationController.setViewControllers([loginVC], animated: false)
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
} 
