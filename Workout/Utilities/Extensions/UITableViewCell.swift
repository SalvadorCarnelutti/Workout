//
//  UITableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
    
    static func assertCellFailure() {
        assertionFailure("There was an issue creating the \(self.identifier) cell")
    }
}
