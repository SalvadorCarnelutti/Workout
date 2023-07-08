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
    static var weekday: Int {
        let calendar = Calendar.current
        let today = Date()

        return calendar.component(.weekday, from: today)
    }
    
    static var weekdayIndex: Int {
        let calendar = Calendar.current
        let today = Date()

        let weekday = calendar.component(.weekday, from: today)

        // Adjust the weekday value to be in the range 0-6
//        let adjustedWeekday = (weekday - calendar.firstWeekday + 7) % 7
        let adjustedWeekday = (weekday - 1 + 7) % 7
        return adjustedWeekday
    }
    
    static var firstWeekday: Int {
        Calendar.current.firstWeekday
    }
    
    func formatAs(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let formattedTime = dateFormatter.string(from: self)
        let formattedDate = dateFormatter.date(from: formattedTime)
        return formattedDate
    }
}
