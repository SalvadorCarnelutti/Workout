//
//  UITableView.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.identifier)
    }
}
