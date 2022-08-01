//
//  Player.swift
//  WerewolfCore
//
//  Created by Hanh Nguyen on 7/17/22.
//

import UIKit

public enum RoleType: String, CaseIterable {
    case werewolf
    case villager
    case bodyguard
    case witch
    case seeker
    case hunter
}

public enum ActionType: Int, CaseIterable {
    case werevovesKill = 1  // 0000 0001
    case witchKill = 2      // 0000 0010
    case hunterKill = 4     // 0000 0100
    case bodyguardSave = 8  // 0000 1000
    case witchSave = 16     // 0001 0000
}

public class Player {
    public var id: String
    public var name: String
    public var role: RoleType = .villager
    public var isDied: Bool = false
    public var status: Int = 0
    
    public init(with name: String, and role: RoleType = .villager) {
        self.id = UUID().uuidString
        self.name = name
        self.role = role
    }
}

extension Player: Equatable {
    public static func ==(left: Player, right: Player) -> Bool {
        return left.id == right.id
    }
}
