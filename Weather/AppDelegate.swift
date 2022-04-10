//
//  AppDelegate.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        boostrapWidow()
        return true
    }

    /// Bootstrap a new window with root view controller to display.
    private func boostrapWidow() {
        if #available(iOS 13, *) {
            // The `SceneDelegate` take reponsibilities for bootstrapping the window.
        } else {
            let window = UIWindow()
            self.window = window
            let viewController = WeatherListBuilder().build()
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, *)
extension AppDelegate {
    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
