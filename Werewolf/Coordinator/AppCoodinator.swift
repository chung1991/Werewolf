//
//  AppCoodinator.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation
import UIKit

class AppCoodinator: Coordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let vc = StepOneController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    func topViewController() -> UIViewController? {
        return navigationController.topViewController
    }
}
