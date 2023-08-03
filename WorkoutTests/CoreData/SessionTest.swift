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
    
    func testWorkoutName() throws {
        let mock = SessionFormOutput.getMock()
        let workout = Workout(context: managedObjectContext)
        let session = Session(context: managedObjectContext)
        
        let workoutName = "Bicep curls"
        workout.setup(with: workoutName)
        
        session.setup(with: mock, for: workout)
        XCTAssertEqual(session.workoutName, workoutName)
    }
    
    func testLongFormattedTimedExercisesDurationString() throws {
        let mock = SessionFormOutput.getMock()
        let workout = Workout(context: managedObjectContext)
        let session = Session(context: managedObjectContext)
        
        let exercise = Exercise(context: managedObjectContext)
        exercise.setup(with: ExerciseFormOutput.getMock(),
                       order: 0,
                       for: workout)
        
        session.setup(with: mock, for: workout)
        
        XCTAssertNil(session.longFormattedTimedExercisesDurationString)
        
        let exerciseFormOutput = ExerciseFormOutput(name: "Dragon flag",
                                                    minutesDuration: 80,
                                                    sets: 5,
                                                    reps: 4)
        exercise.update(with: exerciseFormOutput)
        
        let longFormattedTimedExercisesDurationString = "1 hour, 20 minutes"
        XCTAssertEqual(session.longFormattedTimedExercisesDurationString, longFormattedTimedExercisesDurationString)
    }

    
    func testFormattedStartsAt() throws {
        let mock = SessionFormOutput.getMock()
        let workout = Workout(context: managedObjectContext)
        let formattedStartsAt = "2:34 PM"
        let session = Session(context: managedObjectContext)
        
        session.setup(with: mock, for: workout)
        XCTAssertEqual(session.formattedStartsAt, formattedStartsAt)
    }
    
    func testExerciseDefaultValues() throws {
        let session = Session(context: managedObjectContext)
        XCTAssertNil(session.uuid)
        XCTAssertEqual(session.weekday, 1)
        XCTAssertNil(session.startsAt)
        XCTAssertNil(session.workout)
    }
    
    func testSetup() throws {
        let mock = SessionFormOutput.getMock()
        let workout = Workout(context: managedObjectContext)
        let session = Session(context: managedObjectContext)
        
        session.setup(with: mock, for: workout)
        
        XCTAssertNotNil(session.uuid)
        XCTAssertEqual(session.weekday, mock.day)
        XCTAssertEqual(session.startsAt, mock.startsAt)
        XCTAssertNotNil(session.workout)
    }
    
    func testUpdate() throws {
        let mock = SessionFormOutput.getMock()
        let workout = Workout(context: managedObjectContext)
        let session = Session(context: managedObjectContext)
        let newSessionFormOutput = SessionFormOutput(day: 5,
                                                     startsAt: mock.startsAt)
        session.setup(with: mock, for: workout)
        
        let uuid = session.uuid
        session.update(with: newSessionFormOutput)
        
        XCTAssertEqual(session.uuid, uuid)
        XCTAssertEqual(session.weekday, newSessionFormOutput.day)
        XCTAssertEqual(session.startsAt, newSessionFormOutput.startsAt)
        XCTAssertNotNil(session.workout)
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
