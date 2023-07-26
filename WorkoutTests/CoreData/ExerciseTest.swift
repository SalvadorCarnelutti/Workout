//
//  ExerciseTest.swift
//  WorkoutTests
//
//  Created by Salvador on 7/21/23.
//

import XCTest
import CoreData
@testable import Workout

final class ExerciseTest: XCTestCase {
    private var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        managedObjectContext = setupCoreDataStack(with: "Workout", in: Bundle.main)
    }

    override func tearDown() {
        managedObjectContext = nil
    }
    
    func testExerciseDefaultValues() throws {
        let exercise = Exercise(context: managedObjectContext)
        XCTAssertNil(exercise.uuid)
        XCTAssertNil(exercise.name)
        XCTAssertEqual(exercise.minutesDuration, 0)
        XCTAssertEqual(exercise.sets, 1)
        XCTAssertEqual(exercise.reps, 1)
        XCTAssertEqual(exercise.order, 0)
        XCTAssertNil(exercise.workout)
    }

    func testDurationString() throws {
        let exercise = Exercise(context: managedObjectContext)
        
        exercise.minutesDuration = 0
        XCTAssertNil(exercise.durationString)
        
        exercise.minutesDuration = 12
        XCTAssertEqual(exercise.durationString, "12")
    }
    
    func testFormattedDurationString() throws {
        let exercise = Exercise(context: managedObjectContext)
        
        exercise.minutesDuration = 0
        XCTAssertNil(exercise.formattedDurationString)
        
        exercise.minutesDuration = 12
        XCTAssertEqual(exercise.formattedDurationString, "12 minutes")
        
        exercise.minutesDuration = 90
        XCTAssertEqual(exercise.formattedDurationString, "1 hour, 30 minutes")
    }
    
    func testSetsString() throws {
        let exercise = Exercise(context: managedObjectContext)
        XCTAssertEqual(exercise.setsString, "1")
        
        exercise.sets = 3
        XCTAssertEqual(exercise.setsString, "3")
    }
    
    func testRepsString() throws {
        let exercise = Exercise(context: managedObjectContext)
        XCTAssertEqual(exercise.repsString, "1")
        
        exercise.reps = 20
        XCTAssertEqual(exercise.repsString, "20")
    }
    
    func testItemOrder() throws {
        let exercise = Exercise(context: managedObjectContext)
        XCTAssertEqual(exercise.itemOrder, 1)
        
        exercise.order = 7
        XCTAssertEqual(exercise.itemOrder, 8)
    }
    
    func testSetupWithNoDuration() throws {
        let mock = ExerciseFormOutput.getMock()
        let mockOrder = 2
        
        let exercise = Exercise(context: managedObjectContext)
        
        let workout = Workout(context: managedObjectContext)
        exercise.setup(with: mock,
                       order: mockOrder,
                       for: workout)
        
        XCTAssertNotNil(exercise.uuid)
        XCTAssertEqual(exercise.name, mock.name)
        XCTAssertEqual(exercise.minutesDuration, 0)
        XCTAssertEqual(exercise.sets, Int16(mock.sets))
        XCTAssertEqual(exercise.reps, Int16(mock.reps))
        XCTAssertEqual(exercise.order, Int16(mockOrder))
        XCTAssertNotNil(exercise.workout)
    }
    
    func testSetupWithDuration() throws {
        let durationMock = ExerciseFormOutput.getDurationMock()
        let durationMockOrder = 5
        
        let exercise = Exercise(context: managedObjectContext)
        
        let workout = Workout(context: managedObjectContext)
        exercise.setup(with: durationMock,
                       order: durationMockOrder,
                       for: workout)
        
        XCTAssertNotNil(exercise.uuid)
        XCTAssertEqual(exercise.name, durationMock.name)
        XCTAssertEqual(exercise.minutesDuration, Double(8))
        XCTAssertEqual(exercise.sets, Int16(durationMock.sets))
        XCTAssertEqual(exercise.reps, Int16(durationMock.reps))
        XCTAssertEqual(exercise.order, Int16(durationMockOrder))
        XCTAssertNotNil(exercise.workout)
    }

    func testUpdateWithNoDuration() throws {
        let mock = ExerciseFormOutput.getMock()
        let mockOrder = 2
        
        let exercise = Exercise(context: managedObjectContext)
        
        let workout = Workout(context: managedObjectContext)
        exercise.setup(with: mock,
                       order: mockOrder,
                       for: workout)
        
        XCTAssertNotNil(exercise.uuid)
        XCTAssertEqual(exercise.name, mock.name)
        XCTAssertEqual(exercise.minutesDuration, 0)
        XCTAssertEqual(exercise.sets, Int16(mock.sets))
        XCTAssertEqual(exercise.reps, Int16(mock.reps))
        XCTAssertEqual(exercise.order, Int16(mockOrder))
        XCTAssertNotNil(exercise.workout)
    }
    
    func testUpdateWithDuration() throws {
        let mock = ExerciseFormOutput.getDurationMock()
        let mockOrder = 2
        
        let exercise = Exercise(context: managedObjectContext)
        
        let workout = Workout(context: managedObjectContext)
        exercise.setup(with: mock,
                       order: mockOrder,
                       for: workout)
        
        XCTAssertNotNil(exercise.uuid)
        XCTAssertEqual(exercise.name, mock.name)
        XCTAssertEqual(exercise.minutesDuration, Double(8))
        XCTAssertEqual(exercise.sets, Int16(mock.sets))
        XCTAssertEqual(exercise.reps, Int16(mock.reps))
        XCTAssertEqual(exercise.order, Int16(mockOrder))
        XCTAssertNotNil(exercise.workout)
    }
}

extension ExerciseFormOutput {
    static func getMock() -> Self {
        ExerciseFormOutput(name: "Crunches",
                           minutesDuration: nil,
                           sets: 3,
                           reps: 12)
    }
    
    static func getDurationMock() -> Self {
        ExerciseFormOutput(name: "Crunches",
                           minutesDuration: 8,
                           sets: 3,
                           reps: 12)
    }
}
