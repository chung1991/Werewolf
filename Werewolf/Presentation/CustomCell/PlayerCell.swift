//
//  PlayerCell.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation
import UIKit
import WerewolfCore

// Username     Role
// textField    [icon]
//              [text]

protocol PlayerCellDelegate: AnyObject {
    func didSelectChangeRole(_ cell: UITableViewCell)
    func didSelectAbility(_ command: ActionType, _ cell: UITableViewCell)
    func didChangeName(_ name: String, _ cell: UITableViewCell)
}

protocol PlayCellProtocol {
    var gameManager: GameManagerProtocol { get set }
    
    func isActionEnabled(_ action: ActionType, for player: Player) -> Bool
    func isActionAppliedEnabled(_ action: ActionType, for player: Player) -> Bool
    func isPlayerDead(for player: Player) -> Bool
}

class PlayCellViewModel: PlayCellProtocol {
    var gameManager: GameManagerProtocol = GameManager.shared
    
    func isActionEnabled(_ action: ActionType, for player: Player) -> Bool {
        return gameManager.isActionEnabled(action, for: player)
    }
    
    func isActionAppliedEnabled(_ action: ActionType, for player: Player) -> Bool {
        return gameManager.isActionApplied(action, for: player)
    }
    
    func isPlayerDead(for player: Player) -> Bool {
        return player.isDied
    }
}

class PlayerCell: UITableViewCell {
    static let id = "PlayerCell"
    lazy var usernameLabel = UILabel()
    lazy var usernameTextfield = UITextField()
    lazy var roleLabel = UILabel()
    lazy var roleAvatar = RoleAvatar()
    lazy var abilityStackView = UIStackView()
    lazy var abilityButtons: [UIButton] = []
    lazy var appliedStatusStackView = UIStackView()
    lazy var appliedStatusViews: [UILabel] = []
    weak var delegate: PlayerCellDelegate?
    var viewModel: PlayCellProtocol = PlayCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAutolayouts()
        setupDelegates()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameTextfield.text = nil
        roleAvatar.reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        usernameLabel.text = "Username"
        contentView.addSubview(usernameLabel)
        
        usernameTextfield.borderStyle = .roundedRect
        contentView.addSubview(usernameTextfield)
        
        roleLabel.text = "Role"
        roleLabel.backgroundColor = .red
        contentView.addSubview(roleLabel)
        roleAvatar.backgroundColor = .green
        contentView.addSubview(roleAvatar)
        
        abilityStackView.axis = .horizontal
        abilityStackView.distribution = .fillEqually
        contentView.addSubview(abilityStackView)
        
        let options = ActionType.allCases
        for option in options {
            let uiButton = UIButton()
            uiButton.setTitle(option.displayName, for: .normal)
            uiButton.tag = option.rawValue
            uiButton.setTitleColor(.label, for: .normal)
            uiButton.backgroundColor = .green
            uiButton.layer.cornerRadius = 5
            abilityStackView.addArrangedSubview(uiButton)
            abilityButtons.append(uiButton)
        }
        
        appliedStatusStackView.axis = .horizontal
        appliedStatusStackView.distribution = .fillEqually
        contentView.addSubview(appliedStatusStackView)
        
        for option in options {
            let label = UILabel()
            label.text = option.displayName
            label.tag = option.rawValue
            appliedStatusStackView.addArrangedSubview(label)
            appliedStatusViews.append(label)
        }
    }
    
    func setupAutolayouts() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextfield.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        roleAvatar.translatesAutoresizingMaskIntoConstraints = false
        abilityStackView.translatesAutoresizingMaskIntoConstraints = false
        appliedStatusStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            
            usernameTextfield.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5.0),
            usernameTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            usernameTextfield.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            roleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            
            roleAvatar.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 5.0),
            roleAvatar.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            roleAvatar.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            roleAvatar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            abilityStackView.topAnchor.constraint(equalTo: roleAvatar.bottomAnchor, constant: 5.0),
            abilityStackView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            abilityStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            abilityStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            
            appliedStatusStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            appliedStatusStackView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            appliedStatusStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            appliedStatusStackView.centerYAnchor.constraint(equalTo: abilityStackView.centerYAnchor)
        ])
    }
    
    func configure(_ player: Player) {
        usernameTextfield.text = player.name
        roleAvatar.configure(player)
        
        for button in abilityButtons {
            guard let actionType = ActionType(rawValue: button.tag) else {
                print("wrong action")
                continue
            }
            
            button.backgroundColor = !viewModel.isPlayerDead(for: player) && viewModel.isActionEnabled(actionType, for: player) ? .green : .gray
        }
        
        for statusView in appliedStatusViews {
            guard let actionType = ActionType(rawValue: statusView.tag) else {
                print("wrong action")
                continue
            }
            statusView.isHidden = !viewModel.isPlayerDead(for: player) && viewModel.isActionAppliedEnabled(actionType, for: player) ? false : true
        }
        
        // if player is dead, mark it red as background
        self.backgroundColor = viewModel.isPlayerDead(for: player) ? .red : .systemBackground
    }
    
    func setupDelegates() {
        usernameTextfield.delegate = self
        for button in abilityButtons {
            button.addTarget(self,
                             action: #selector(didTapAbilityButton(_:)),
                             for: .touchUpInside)
        }

        roleAvatar.delegate = self
    }
    
    @objc func didTapAbilityButton(_ button: UIButton) {
        guard let command = ActionType(rawValue: button.tag) else {
            print ("command is nil")
            return
        }
        delegate?.didSelectAbility(command, self)
    }
}

extension PlayerCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        delegate?.didChangeName(text, self)
    }
}

extension PlayerCell: RoleAvatarDelegate {
    func didSelectChangeRole() {
        delegate?.didSelectChangeRole(self)
    }
}
