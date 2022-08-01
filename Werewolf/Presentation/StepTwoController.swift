//
//  StepTwoController.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import UIKit
import WerewolfCore

extension ActionType {
    var displayName: String {
        switch self {
        case .werevovesKill:
            return "🐺"
        case .witchKill:
            return "☠️"
        case .hunterKill:
            return "🔫"
        case .bodyguardSave:
            return "🛡️"
        case .witchSave:
            return "⚱️"
        }
    }
}

//enum Role: String, CaseIterable, DropDownObject {
//    var displayString: String {
//        return self.rawValue
//    }
//
//    case Witch, Bodyguard, Seer, Hunter, Villager, Werewolf
//}
//
//struct UserPlayer: DropDownObject {
//    var displayString: String {
//        return self.username
//    }
//
//    var username: String
//    var role: Role
//}

extension RoleType: DropDownObject {
    var displayString: String {
        return self.rawValue
    }
}

extension Player: DropDownObject {
    var displayString: String{
        return self.name
    }
}

protocol StepTwoViewModel {
    var gameManager: GameManagerProtocol { get set }
    var numberOfPlayers: Int { get set }
    var players: [Player] { get set }
    func reloadData(_ numberOfPlayers: Int)
    func updateRole(_ role: RoleType, _ playerIndex: Int)
    func updateName(_ name: String, _ playerIndex: Int)
    func applyAction(for player: Player, action: DropDownPurpose)
    func getTodayStatus() -> String
    func getNextButtonTitle() -> String
    func isEndGame() -> Bool
    func nextNight()
}

class StepTwoViewModelImpl: StepTwoViewModel {
    var gameManager: GameManagerProtocol = GameManager()
    var numberOfPlayers: Int = 0
    var players: [Player] = []
    
    func reloadData(_ numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        players = []
        for i in 0..<numberOfPlayers {
            let playerName = "Player\(i+1)"
            let role: RoleType = .villager
            let player = Player(with: playerName, and: role)
            players.append(player)
        }
        gameManager.setPlayers(players)
    }
    func updateRole(_ role: RoleType, _ playerIndex: Int) {
        guard playerIndex < players.count else {
            print ("player index is exceed")
            return
        }
        players[playerIndex].role = role
    }
    
    func updateName(_ name: String, _ playerIndex: Int) {
        guard playerIndex < players.count else {
            print ("player index is exceed")
            return
        }
        players[playerIndex].name = name
    }
    
    func applyAction(for player: Player, action: DropDownPurpose) {
        guard let action = action as? ActionType else {
            print("Wrong action")
            return
        }
        gameManager.setAction(action, for: player)
    }
    
    func getTodayStatus() -> String {
        let number = gameManager.getGameNumber()
        if number == 0 {
            return "Start"
        }
        return "Night \(number)"
    }
    
    func getNextButtonTitle() -> String {
        let number = gameManager.getGameNumber()
        if number == 0 {
            return "Start"
        }
        return "Next"
    }
    
    func isEndGame() -> Bool {
        return gameManager.checkEndGame()
    }
    
    func nextNight() {
        gameManager.nextStage()
    }
}

protocol StepTwoControllerDelegate: AnyObject {
    func didSelectChangeRole(_ indexPath: IndexPath)
    func didSelectAbility(_ command: ActionType, _ indexPath: IndexPath, _ players: [Player])
    func didEndGame(_ title: String)
}

class StepTwoController: UIViewController {
    lazy var viewModel: StepTwoViewModel = StepTwoViewModelImpl()
    lazy var tableView = UITableView()
    weak var delegate: StepTwoControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayouts()
        setupDelegates()
        reloadData()
    }
    
    func configure(_ numberOfPlayer: Int) {
        viewModel.reloadData(numberOfPlayer)
        reloadData()
    }
    
    func configure(_ role: RoleType, _ playerIndexPath: IndexPath) {
        viewModel.updateRole(role, playerIndexPath.row)
        reloadData()
    }
    
    func applyAction(_ player: Player, _ playerIndexPath: IndexPath, purpose: DropDownPurpose) {
        viewModel.applyAction(for: player, action: purpose)
        reloadData()
    }
    
    func reloadData() {
        navigationItem.title = viewModel.getTodayStatus()
        navigationItem.rightBarButtonItem?.title = viewModel.getNextButtonTitle()
        navigationItem.hidesBackButton = !(navigationItem.title == "Start")
        tableView.reloadData()
    }

    func setupViews() {
        setupNavigationBar()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func setupNavigationBar() {
        //navigationItem.title = viewModel.getTodayStatus()
        let nextButtonItem = UIBarButtonItem(title: "N/A")
        nextButtonItem.target = self
        nextButtonItem.action = #selector(didTapRightBarButton)
        navigationItem.rightBarButtonItem = nextButtonItem
    }
    
    func setupAutolayouts() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setupDelegates() {
        tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didTapRightBarButton() {
        if viewModel.isEndGame() {
            delegate?.didEndGame("End game")
        } else {
            viewModel.nextNight()
        }
        reloadData()
    }
}

extension StepTwoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.id, for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }
        let player = viewModel.players[indexPath.row]
        cell.configure(player)
        cell.delegate = self
        return cell
    }
}

extension StepTwoController: PlayerCellDelegate {
    func didSelectAbility(_ command: ActionType, _ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            print ("can not find index path")
            return
        }
        delegate?.didSelectAbility(command, indexPath, viewModel.players)
    }
    
    func didSelectChangeRole(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            print ("can not find index path")
            return
        }
        delegate?.didSelectChangeRole(indexPath)
    }
    
    func didChangeName(_ name: String, _ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            print ("can not find index path")
            return
        }
        viewModel.updateName(name, indexPath.row)
    }
}



