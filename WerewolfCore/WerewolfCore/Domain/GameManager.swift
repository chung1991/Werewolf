//
//  GameManager.swift
//  WerewolfCore
//
//  Created by Hanh Nguyen on 7/17/22.
//

import UIKit

public protocol GameManagerProtocol {
    func setPlayers(_ players: [Player])
    
    func setAction(_ action: ActionType, for player: Player)
    
    func checkDie(for player: Player) -> Bool
    
    func checkStatusAllPlayers(_ players: [Player])
    
    func getDiedPlayers() -> [Player]
    
    func getLivePlayers() -> [Player]
    
    func checkEndGame() -> Bool
    
    func nextStage()
    
    func isActionEnabled(_ actionType: ActionType, for player: Player) -> Bool
    
    func isActionApplied(_ action: ActionType, for player: Player) -> Bool
    
    func getGameNumber() -> Int
}

public class GameManager: GameManagerProtocol {
    public static let shared: GameManagerProtocol = GameManager()
    
    var game: Game = Game()
    var playerManager: PlayerManagerProtocol = PlayerManager()
    
    public init() {
        
    }
    
    public func setPlayers(_ players: [Player]) {
        self.game.allPlayers = players
    }
    
    public func setAction(_ action: ActionType, for player: Player) {
        player.status |= action.rawValue
    }
    
    public func checkDie(for player: Player) -> Bool {
        let status = player.status
        let werewolvesKill = (status & ActionType.werevovesKill.rawValue) == ActionType.werevovesKill.rawValue
        let witchKill = (status & ActionType.witchKill.rawValue) == ActionType.witchKill.rawValue
        let isKilled = werewolvesKill || witchKill

        let witchSave = (status & ActionType.witchSave.rawValue) == ActionType.witchSave.rawValue
        let bodyguardSave = (status & ActionType.bodyguardSave.rawValue) == ActionType.bodyguardSave.rawValue
        let isSaved = witchSave || bodyguardSave
        
        return (isKilled && !isSaved)
    }
    
    public func checkStatusAllPlayers(_ players: [Player]) {
        for player in game.allPlayers {
            player.isDied = checkDie(for: player)
        }
    }
    
    public func getDiedPlayers() -> [Player] {
        checkStatusAllPlayers(game.allPlayers)
        
        let diedPlayers = game.allPlayers.filter({ $0.isDied })
        return diedPlayers
    }
    
    public func getLivePlayers() -> [Player] {
        checkStatusAllPlayers(game.allPlayers)
        
        let livePlayers = game.allPlayers.filter({ $0.isDied == false })
        return livePlayers
    }
    
    public func checkEndGame() -> Bool {
        let leftPlayers = getLivePlayers()
        
        // All players were died
        let leftPlayersCount = leftPlayers.count
        guard leftPlayersCount > 0 else {
            return true
        }
        
        let leftWerewoves = leftPlayers.filter({ $0.role == .werewolf })
        let leftWerewovesCount = leftWerewoves.count
        guard leftWerewovesCount > 0 else {
            return true
        }
        
        let leftVillagersCount = leftPlayersCount - leftWerewovesCount
        
        if leftWerewovesCount >= leftVillagersCount {
            return true
        }
        
        return false
    }
    
    public func nextStage() {
        game.number += 1
        
        var nextPlayers: [Player] = []
        
        for player in game.allPlayers {
            if player.isDied {
                if game.deadPlayers.contains(player) {
                    continue
                }
                
                game.deadPlayers.append(player)
            } else {
                // Reset status
                playerManager.resetStatus(for: player)
                
                // Next players
                nextPlayers.append(player)
            }
        }
        
        game.allPlayers = nextPlayers
    }
    
    public func isActionEnabled(_ actionType: ActionType, for player: Player) -> Bool {
        switch actionType {
        case .werevovesKill:
            return player.role == .werewolf
        case .witchKill:
            return player.role == .witch
        case .hunterKill:
            return player.role == .hunter
        case .bodyguardSave:
            return player.role == .bodyguard
        case .witchSave:
            return player.role == .witch
        }
    }
    
    public func isActionApplied(_ action: ActionType, for player: Player) -> Bool {
        return (player.status & action.rawValue) == action.rawValue
    }
    
    public func getGameNumber() -> Int {
        return game.number
    }
}
