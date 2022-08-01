//
//  Character+Ext.swift
//  Werewolf
//
//  Created by Chung Nguyen on 7/17/22.
//

import Foundation

extension Character {
    func isDigit() -> Bool {
        let gap = Int(self.asciiValue!) - Int(Character("0").asciiValue!)
        return gap >= 0 && gap <= 9
    }
}
