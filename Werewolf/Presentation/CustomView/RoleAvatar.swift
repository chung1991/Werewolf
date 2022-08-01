//
//  RoleAvatar.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation
import UIKit
import WerewolfCore

protocol RoleAvatarDelegate: AnyObject {
    func didSelectChangeRole()
}

class RoleAvatar: UIView {
    lazy var roleImage = UIImageView()
    lazy var roleButton = UIButton()
    
    var id: Int = -1
    weak var delegate: RoleAvatarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAutolayouts()
        setupDelegates()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ id: Int) {
        self.id = id
    }
    
    func setupViews() {
        roleImage.contentMode = .scaleAspectFit
        addSubview(roleImage)
        
        roleButton.setTitleColor(.label, for: .normal)
        roleButton.backgroundColor = .green
        roleButton.layer.cornerRadius = 5
        addSubview(roleButton)
    }
    
    func setupAutolayouts() {
        roleImage.translatesAutoresizingMaskIntoConstraints = false
        roleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roleImage.topAnchor.constraint(equalTo: topAnchor),
            roleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            roleImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            roleButton.topAnchor.constraint(equalTo: roleImage.bottomAnchor),
            roleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            roleButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    func setupDelegates() {
        roleButton.addTarget(self,
                       action: #selector(didSelectIcon),
                       for: .touchUpInside)
    }
    func reloadData() {
        
    }
    
    @objc func didSelectIcon() {    
        delegate?.didSelectChangeRole()
    }
    
    func reset() {
        roleImage.image = nil
        roleButton.setTitle(nil, for: .normal)
    }
    
    func configure(_ player: Player) {
        roleImage.image = UIImage(named: player.role.rawValue)
        roleButton.setTitle(player.role.rawValue, for: .normal)
    }
}
