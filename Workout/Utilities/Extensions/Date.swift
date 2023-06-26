//
//  Date.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import Foundation

extension Date {
    static var weekday: Int {
        let calendar = Calendar.current
        let today = Date()

        let weekday = calendar.component(.weekday, from: today)

        // Adjust the weekday value to be in the range 0-6
        let adjustedWeekday = (weekday - calendar.firstWeekday + 7) % 7
        return adjustedWeekday
    }
    
    func formatAs(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let formattedTime = dateFormatter.string(from: self)
        let formattedDate = dateFormatter.date(from: formattedTime)
        return formattedDate
    }
}
