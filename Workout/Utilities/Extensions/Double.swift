//
//  Double.swift
//  Workout
//
//  Created by Salvador on 7/5/23.
//

import Foundation

extension Double {
    var asLongFormattedDurationString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        
        return formatter.string(from: TimeInterval(self * 60))
    }
    
    var asShortFormattedDurationString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short

        return formatter.string(from: TimeInterval(self * 60))
    }
}
