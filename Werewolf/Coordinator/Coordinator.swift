//
//  Coordinator.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
