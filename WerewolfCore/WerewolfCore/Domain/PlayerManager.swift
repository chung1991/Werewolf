//
//  PlayerManager.swift
//  WerewolfCore
//
//  Created by Hanh Nguyen on 7/17/22.
//

import UIKit

public protocol PlayerManagerProtocol {

    func resetStatus(for player: Player)
}

public class PlayerManager: PlayerManagerProtocol {
    
    public func resetStatus(for player: Player) {
        player.status = 0
    }
}
