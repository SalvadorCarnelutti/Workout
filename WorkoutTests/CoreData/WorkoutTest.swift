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
        
        for i in 1...5 {
            let exercise = Exercise(context: managedObjectContext)
            exercise.workout = workout
            
            XCTAssertEqual(workout.exercisesCount, i)
        }
    }
    
    func testSessionsCount() throws {
        let workout = Workout(context: managedObjectContext)
        let sessions = [Session(context: managedObjectContext), Session(context: managedObjectContext)]
        
        sessions.forEach { $0.workout = workout }
        
        XCTAssertEqual(workout.sessionsCount, 2)
    }
    
    func testTimedExercisesCount() throws {
        let workout = Workout(context: managedObjectContext)
        let exercises = [Exercise(context: managedObjectContext), Exercise(context: managedObjectContext), Exercise(context: managedObjectContext)]
        
        exercises.forEach { $0.workout = workout }
        
        XCTAssertEqual(workout.exercisesCount, 3)
    }
    
    func testTimedExercisesDuration() throws {
        let workout = Workout(context: managedObjectContext)
        var exercisesDuration = 0
        
        for i in 0...4 {
            let exercise = Exercise(context: managedObjectContext)
            let exerciseDuration = i * 10
            let exerciseFormOutput = ExerciseFormOutput(name: "Exercise \(i)",
                                                        minutesDuration: exerciseDuration,
                                                        sets: 3,
                                                        reps: 10)
            exercise.setup(with: exerciseFormOutput,
                           order: i,
                           for: workout)
            
            exercisesDuration += exerciseDuration
        }
                
        XCTAssertEqual(workout.timedExercisesDuration, exercisesDuration)
    }
    
    func testSetup() throws {
        let workout = Workout(context: managedObjectContext)
        let workoutName = "Abs workout"
        
        workout.setup(with: workoutName)
        
        XCTAssertEqual(workout.name, workoutName)
    }
    
    func testUpdate() throws {
        let workout = Workout(context: managedObjectContext)
        let workoutName = "Abs workout"
        let newWorkoutName = "Dumbbell workout"
        
        workout.setup(with: workoutName)
        
        let uuid = workout.uuid
        workout.update(with: newWorkoutName)
        
        XCTAssertEqual(workout.uuid, uuid)
        XCTAssertEqual(workout.name, newWorkoutName)
    }
    
    func testLongFormattedTimedExercisesDurationString() throws {
        let workout = Workout(context: managedObjectContext)
        
        let exercise = Exercise(context: managedObjectContext)
        exercise.setup(with: ExerciseFormOutput.getMock(),
                       order: 0,
                       for: workout)
        
        XCTAssertNil(workout.longFormattedTimedExercisesDurationString)
        
        let exerciseFormOutput = ExerciseFormOutput(name: "Dragon flag",
                                                    minutesDuration: 80,
                                                    sets: 5,
                                                    reps: 4)
        exercise.update(with: exerciseFormOutput)
        
        let longFormattedTimedExercisesDurationString = "1 hour, 20 minutes"
        XCTAssertEqual(workout.longFormattedTimedExercisesDurationString, longFormattedTimedExercisesDurationString)
    }
    
    func testShortFormattedTimedExercisesDurationString() throws {
        let workout = Workout(context: managedObjectContext)
        
        let exercise = Exercise(context: managedObjectContext)
        exercise.setup(with: ExerciseFormOutput.getMock(),
                       order: 0,
                       for: workout)
        
        XCTAssertNil(workout.shortFormattedTimedExercisesDurationString)
        
        let exerciseFormOutput = ExerciseFormOutput(name: "Dragon flag",
                                                    minutesDuration: 80,
                                                    sets: 5,
                                                    reps: 4)
        exercise.update(with: exerciseFormOutput)
        
        let shortFormattedTimedExercisesDurationString = "1 hr, 20 min"
        XCTAssertEqual(workout.shortFormattedTimedExercisesDurationString, shortFormattedTimedExercisesDurationString)
    }
    
    func testEmptySessions() throws {
        let workout = Workout(context: managedObjectContext)
        let sessions = [Session(context: managedObjectContext), Session(context: managedObjectContext)]
        
        sessions.forEach { $0.workout = workout }
        workout.emptySessions()

        let expectation = XCTestExpectation(description: "Deleting from the persistent store is not immediate")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(workout.sessionsCount, 0)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
