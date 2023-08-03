//
//  SessionTest.swift
//  WorkoutTests
//
//  Created by Salvador on 8/2/23.
//

import XCTest
import CoreData
@testable import Workout

final class SessionTest: XCTestCase {
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        managedObjectContext = setupCoreDataStack(with: "Workout", in: Bundle.main)
    }
    
    override func tearDown() {
        managedObjectContext = nil
    }
    
    func testExerciseDefaultValues() throws {
        let session = Session(context: managedObjectContext)
        XCTAssertNil(session.uuid)
        XCTAssertEqual(session.weekday, 1)
        XCTAssertNil(session.startsAt)
        XCTAssertNil(session.workout)
    }
}

extension SessionFormOutput {
    static func getMock() -> Self {
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 34
        
        let userCalendar = Calendar(identifier: .gregorian)
        let someDateTime = userCalendar.date(from: dateComponents)!
        
        return SessionFormOutput(day: 3,
                                 startsAt: someDateTime)
    }
}
