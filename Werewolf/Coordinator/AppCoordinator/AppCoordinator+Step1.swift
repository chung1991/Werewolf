//
//  AppCoordinator+Step1.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation

extension AppCoodinator: StepOneControllerDelegate {
    func moveToStep2(_ numberOfPlayer: Int) {
        let vc = StepTwoController()
        vc.delegate = self
        vc.configure(numberOfPlayer)
        navigationController.pushViewController(vc, animated: true)
    }
}
