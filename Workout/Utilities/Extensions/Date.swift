//
//  Date.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import Foundation

/*
 Calendar framework
 Sunday: 1
 Monday: 2
 Tuesday: 3
 Wednesday: 4
 Thursday: 5
 Friday: 6
 Saturday: 7
 */

extension Date {
    static var currentWeekday: Int {
        let calendar = Calendar.current
        let today = Date()

        return calendar.component(.weekday, from: today)
    }
    
    static var currentWeekdayIndex: Int {
        let calendar = Calendar.current
        let today = Date()

        let weekday = calendar.component(.weekday, from: today)

        // Adjust the currentWeekday value to be in the range 0-6
        let adjustedWeekday = (weekday - 1 + 7) % 7
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
