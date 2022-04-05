//
//  SceneDelegate.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import UIKit

/// An object that manages app-specific tasks occurring in a scene.
@available(iOS 13, macCatalyst 13, tvOS 13, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        boostrapWindow(from: scene)
    }

    // MARK: Side Effects

    /// Bootstrap a new window with root view controller to display.
    ///
    /// If the bootstrapping is success, it will share the initialized window to `AppDelegate`.
    ///
    /// - Parameter scene: An object that represents one instance of the app's user interface.
    func boostrapWindow(from scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        // Make a window and then save it for later usuage.
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        // Make initial view controller.
        let viewController = WeatherListingBuilder().build()
        let navigationController = UINavigationController(rootViewController: viewController)
        // Display the initial view controller.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        // Share the window to the `AppDelegate`.
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }
}
