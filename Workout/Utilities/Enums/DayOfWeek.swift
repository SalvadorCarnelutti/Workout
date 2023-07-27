//
//  DayOfWeek.swift
//  Workout
//
//  Created by Salvador on 7/27/23.
//

import Foundation

enum DayOfWeek: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .sunday
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        default: return nil
        }
    }
    
    var longDescription: String {
        switch self {
        case .sunday:
            return String(localized: "Sunday")
        case .monday:
            return String(localized: "Monday")
        case .tuesday:
            return String(localized: "Tuesday")
        case .wednesday:
            return String(localized: "Wednesday")
        case .thursday:
            return String(localized: "Thursday")
        case .friday:
            return String(localized: "Friday")
        case .saturday:
            return String(localized: "Saturday")
        }
    }
    
    var shortDescription: String {
        switch self {
        case .sunday:
            return String(localized: "Sun")
        case .monday:
            return String(localized: "Mon")
        case .tuesday:
            return String(localized: "Tue")
        case .wednesday:
            return String(localized: "Wed")
        case .thursday:
            return String(localized: "Thu")
        case .friday:
            return String(localized: "Fri")
        case .saturday:
            return String(localized: "Sat")
        }
    }
    
    var compactDescription: String {
        switch self {
        case .sunday:
            return String(localized: "compactSunday")
        case .monday:
            return String(localized: "compactMonday")
        case .tuesday:
            return String(localized: "compactTuesday")
        case .wednesday:
            return String(localized: "compactWednesday")
        case .thursday:
            return String(localized: "compactThursday")
        case .friday:
            return String(localized: "compactFriday")
        case .saturday:
            return String(localized: "compactSaturday")
        }
    }
}
