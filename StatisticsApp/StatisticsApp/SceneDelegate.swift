//
//  SceneDelegate.swift
//  StatisticsApp
//
//  Created by Татьяна Исаева on 09.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: windowScene)
		window?.windowScene = windowScene
		window?.makeKeyAndVisible()
		window?.rootViewController = StatsViewController()
	}
}

