//
//  String.swift
//  Workout
//
//  Created by Salvador on 6/5/23.
//

import UIKit

extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
