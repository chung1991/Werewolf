//
//  Game.swift
//  WerewolfCore
//
//  Created by Hanh Nguyen on 7/17/22.
//

import UIKit

public enum TimeType {
    case day
    case night
}

public class Game {
    var number: Int = 0
    var time: TimeType = .night
    var allPlayers: [Player] = []
    var deadPlayers: [Player] = []
    var villagers: [Player] = []
    var werewoves: [Player] = []
    var witch: Player?
    var bodyguard: Player?
    var hunter: Player?
    
    init() {
    }
}

