//
//  GameManagerTests.swift
//  WerewolfCoreTests
//
//  Created by Chung Nguyen on 6/18/26.
//

import XCTest
@testable import WerewolfCore

final class GameManagerTests: XCTestCase {
    private var sut: GameManager!

    override func setUpWithError() throws {
        sut = GameManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - setAction

    func testSetActionAccumulatesStatus() {
        let player = Player(with: "P1")
        sut.setAction(.werevovesKill, for: player)
        sut.setAction(.bodyguardSave, for: player)
        XCTAssertTrue(sut.isActionApplied(.werevovesKill, for: player))
        XCTAssertTrue(sut.isActionApplied(.bodyguardSave, for: player))
        XCTAssertFalse(sut.isActionApplied(.witchKill, for: player))
    }

    func testSetActionIsIdempotent() {
        let player = Player(with: "P1")
        sut.setAction(.witchKill, for: player)
        sut.setAction(.witchKill, for: player)
        XCTAssertEqual(player.status, ActionType.witchKill.rawValue)
    }

    // MARK: - isActionEnabled

    func testIsActionEnabledMatchesRole() {
        let werewolf = Player(with: "W", and: .werewolf)
        let witch = Player(with: "Wi", and: .witch)
        let hunter = Player(with: "H", and: .hunter)
        let bodyguard = Player(with: "B", and: .bodyguard)
        let villager = Player(with: "V", and: .villager)

        XCTAssertTrue(sut.isActionEnabled(.werevovesKill, for: werewolf))
        XCTAssertTrue(sut.isActionEnabled(.witchKill, for: witch))
        XCTAssertTrue(sut.isActionEnabled(.witchSave, for: witch))
        XCTAssertTrue(sut.isActionEnabled(.hunterKill, for: hunter))
        XCTAssertTrue(sut.isActionEnabled(.bodyguardSave, for: bodyguard))

        XCTAssertFalse(sut.isActionEnabled(.werevovesKill, for: villager))
        XCTAssertFalse(sut.isActionEnabled(.witchKill, for: werewolf))
        XCTAssertFalse(sut.isActionEnabled(.hunterKill, for: villager))
    }

    // MARK: - getDiedPlayers / getLivePlayers

    func testGetDiedAndLivePlayersPartition() {
        let alive = Player(with: "Alive", and: .villager)
        let killed = Player(with: "Killed", and: .villager)
        sut.setPlayers([alive, killed])
        sut.setAction(.werevovesKill, for: killed)

        let died = sut.getDiedPlayers()
        let live = sut.getLivePlayers()

        XCTAssertEqual(died.map { $0.id }, [killed.id])
        XCTAssertEqual(live.map { $0.id }, [alive.id])
    }

    // MARK: - checkEndGame

    func testGameEndsWhenAllPlayersDead() {
        let p1 = Player(with: "P1", and: .werewolf)
        let p2 = Player(with: "P2", and: .villager)
        sut.setPlayers([p1, p2])
        sut.setAction(.werevovesKill, for: p1)
        sut.setAction(.werevovesKill, for: p2)
        XCTAssertTrue(sut.checkEndGame())
    }

    func testGameEndsWhenNoWerewolvesLeft() {
        let werewolf = Player(with: "W", and: .werewolf)
        let v1 = Player(with: "V1", and: .villager)
        let v2 = Player(with: "V2", and: .villager)
        sut.setPlayers([werewolf, v1, v2])
        sut.setAction(.witchKill, for: werewolf)
        XCTAssertTrue(sut.checkEndGame())
    }

    func testGameEndsAtWerewolfParity() {
        // 1 werewolf vs 1 villager -> werewolves win (parity)
        let werewolf = Player(with: "W", and: .werewolf)
        let villager = Player(with: "V", and: .villager)
        sut.setPlayers([werewolf, villager])
        XCTAssertTrue(sut.checkEndGame())
    }

    func testGameContinuesWhenVillagersOutnumberWerewolves() {
        let werewolf = Player(with: "W", and: .werewolf)
        let v1 = Player(with: "V1", and: .villager)
        let v2 = Player(with: "V2", and: .villager)
        sut.setPlayers([werewolf, v1, v2])
        XCTAssertFalse(sut.checkEndGame())
    }

    // MARK: - nextStage

    func testNextStageIncrementsGameNumber() {
        XCTAssertEqual(sut.getGameNumber(), 0)
        sut.setPlayers([Player(with: "P1", and: .villager)])
        sut.nextStage()
        XCTAssertEqual(sut.getGameNumber(), 1)
    }

    func testNextStageResetsStatusOfLivePlayers() {
        let alive = Player(with: "Alive", and: .villager)
        sut.setPlayers([alive])
        sut.setAction(.werevovesKill, for: alive)
        sut.setAction(.bodyguardSave, for: alive) // survives
        _ = sut.getLivePlayers() // refresh isDied before advancing
        sut.nextStage()
        XCTAssertEqual(alive.status, 0)
    }

    func testNextStageMovesDeadPlayersOut() {
        let alive = Player(with: "Alive", and: .villager)
        let killed = Player(with: "Killed", and: .villager)
        sut.setPlayers([alive, killed])
        sut.setAction(.werevovesKill, for: killed)
        _ = sut.getLivePlayers() // refresh isDied before advancing
        sut.nextStage()

        XCTAssertEqual(sut.game.allPlayers.map { $0.id }, [alive.id])
        XCTAssertEqual(sut.game.deadPlayers.map { $0.id }, [killed.id])
    }

    func testNextStageDoesNotDuplicateDeadPlayers() {
        let killed = Player(with: "Killed", and: .villager)
        let alive = Player(with: "Alive", and: .werewolf)
        sut.setPlayers([alive, killed])
        sut.setAction(.werevovesKill, for: killed)
        _ = sut.getLivePlayers()
        sut.nextStage()
        sut.nextStage()
        XCTAssertEqual(sut.game.deadPlayers.filter { $0.id == killed.id }.count, 1)
    }
}
