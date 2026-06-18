//
//  GameManagerCheckDieTests.swift
//  WerewolfCoreTests
//
//  Created by Chung Nguyen on 6/12/26.
//

import XCTest
@testable import WerewolfCore

final class GameManagerCheckDieTests: XCTestCase {
    private var sut: GameManager!

    override func setUpWithError() throws {
        sut = GameManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - No action

    func testPlayerWithNoActionDoesNotDie() {
        let player = Player(with: "P1", and: .villager)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    // MARK: - Kills

    func testWerewolfKillKillsPlayer() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.werevovesKill, for: player)
        XCTAssertTrue(sut.checkDie(for: player))
    }

    func testWitchKillKillsPlayer() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.witchKill, for: player)
        XCTAssertTrue(sut.checkDie(for: player))
    }

    // Regression test for the hunterKill bug: a hunter's shot must kill the target.
    func testHunterKillKillsPlayer() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.hunterKill, for: player)
        XCTAssertTrue(sut.checkDie(for: player))
    }

    // MARK: - Saves

    func testWitchSaveAloneDoesNotKill() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.witchSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    func testBodyguardSaveAloneDoesNotKill() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.bodyguardSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    // MARK: - Kill + Save combinations

    func testWerewolfKillNegatedByWitchSave() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.werevovesKill, for: player)
        sut.setAction(.witchSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    func testWerewolfKillNegatedByBodyguardSave() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.werevovesKill, for: player)
        sut.setAction(.bodyguardSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    func testHunterKillNegatedBySave() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.hunterKill, for: player)
        sut.setAction(.bodyguardSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }

    func testMultipleKillsStillNegatedBySave() {
        let player = Player(with: "P1", and: .villager)
        sut.setAction(.werevovesKill, for: player)
        sut.setAction(.hunterKill, for: player)
        sut.setAction(.witchSave, for: player)
        XCTAssertFalse(sut.checkDie(for: player))
    }
}
