//
//  String.swift
//  Workout
//
//  Created by Salvador on 6/5/23.
//

import Foundation

extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localizedWithFormat(_ arguments: CVarArg...) -> String {
        String.localizedStringWithFormat(localized, arguments)
    }
}
