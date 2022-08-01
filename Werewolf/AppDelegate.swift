//
//  AppDelegate.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import UIKit
import WerewolfCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoodinator(navigationController: UINavigationController())
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
        coordinator?.start()
        //(coordinator as? AppCoodinator)?.moveToStep2(5)
        return true
    }

}

