//
//  SceneDelegate.swift
//  Checklist
//
//  Created by Vesela Stamenova on 22.11.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func sceneDidDisconnect(_ scene: UIScene) {
		DataModel.shared.saveChecklist()
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
		DataModel.shared.saveChecklist()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		DataModel.shared.saveChecklist()
	}
}

