//
//  AppCoordinator+Step2.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/20/22.
//

import Foundation
import WerewolfCore
import UIKit

extension AppCoodinator: StepTwoControllerDelegate {
    func didSelectAbility(_ command: ActionType, _ indexPath: IndexPath, _ players: [Player]) {
        guard let vc = topViewController() else {
            print ("top vc is nil")
            return
        }
        let dropDownVc = DropDownSelectionController()
        dropDownVc.delegate = self
        dropDownVc.configure(indexPath, players, purpose: command)
        dropDownVc.modalPresentationStyle = .formSheet
        vc.present(dropDownVc, animated: true, completion: nil)
    }
    
    func didSelectChangeRole(_ indexPath: IndexPath) {
        guard let vc = topViewController() else {
            print ("top vc is nil")
            return
        }
        let dropDownVc = DropDownSelectionController()
        dropDownVc.delegate = self
        dropDownVc.configure(indexPath, RoleType.allCases)
        dropDownVc.modalPresentationStyle = .formSheet
        vc.present(dropDownVc, animated: true, completion: nil)
    }
    
    func didEndGame(_ title: String) {
        guard let vc = topViewController() as? StepTwoController else {
            print ("top vc is nil")
            return
        }
        let alert = UIAlertController(title: "Game is end", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // reset games
            self?.navigationController.popViewController(animated: true)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}

extension AppCoodinator: DropDownSelectionDelegate {
    func didSelect(_ object: DropDownObject, _ returnTo: IndexPath, purpose: DropDownPurpose) {
        guard let vc = topViewController() as? StepTwoController else {
            print ("top vc is nil or not step two controller")
            return
        }
        if let role = object as? RoleType {
            vc.configure(role, returnTo)
        }
        if let player = object as? Player {
            vc.applyAction(player, returnTo, purpose: purpose)
        }
        
    }
}
