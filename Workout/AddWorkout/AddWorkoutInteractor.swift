//
//  
//  AddWorkoutInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import Foundation
import CoreData

protocol AddWorkoutPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var managedObjectContext: NSManagedObjectContext { get }
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutInteractor: AddWorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let persistentContainer: NSPersistentContainer
    
    private var exercises = [Exercise]()
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
