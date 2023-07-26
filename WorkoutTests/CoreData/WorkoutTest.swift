//
//  WorkoutTest.swift
//  WorkoutTests
//
//  Created by Salvador on 7/21/23.
//

import XCTest
import CoreData
@testable import Workout

final class WorkoutTest: XCTestCase {
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        managedObjectContext = setupCoreDataStack(with: "Workout", in: Bundle.main)
    }
    
    override func tearDown() {
        managedObjectContext = nil
    }
    
    func testWorkoutDefaultValues() throws {
        let workout = Workout(context: managedObjectContext)
        XCTAssertNil(workout.uuid)
        XCTAssertNil(workout.name)
        XCTAssertEqual(workout.exercises?.map { $0 as? Exercise }.count, 0)
        XCTAssertEqual(workout.sessions?.map { $0 as? Session }.count, 0)
    }
    
    func testExercisesCount() throws {
        let workout = Workout(context: managedObjectContext)
        
    }
    
    func testSessionsCount() throws {
        let workout = Workout(context: managedObjectContext)
        
    }
}

//extension Workout {
//    var timedExercisesCount: Int {
//        compactMappedExercises.filter { $0.minutesDuration > 0 }.count
//    }
//    
//    var timedExercisesDuration: Int {
//        compactMappedExercises.reduce (0, { $0 + Int($1.minutesDuration) })
//    }
//    
//    var longFormattedTimedExercisesDurationString: String? {
//        guard timedExercisesDuration > 0 else { return nil }
//        
//        return Double(timedExercisesDuration).asLongFormattedDurationString
//    }
//    
//    var shortFormattedTimedExercisesDurationString: String? {
//        Double(timedExercisesDuration).asShortFormattedDurationString
//    }
//    
//    func setup(with name: String) {
//        uuid = UUID()
//        self.name = name
//        Logger.coreData.info("New workout \(self) added to managed object context")
//    }
//    
//    func update(with newName: String) {
//        self.name = newName
//        Logger.coreData.info("Workout updated to \(self) in current managed object context")
//    }
//    
//    func emptySessions() { compactMappedSessions.forEach { $0.delete() } }
//}
