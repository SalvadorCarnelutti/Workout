//
//  
//  SessionsPresenter.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
//

import UIKit
import CoreData

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

protocol SessionsViewToPresenterProtocol: AnyObject {
    var view: SessionsPresenterToViewProtocol! { get set }
    var workoutName: String { get }
    var sessionsCount: Int { get }
    func viewLoaded()
    func addSessionTapped()
    func session(at indexPath: IndexPath) -> Session
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}


protocol SessionsRouterToPresenterProtocol: AnyObject {
    func addCompletionAction(formOutput: SessionFormOutput)
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

typealias SessionsPresenterProtocol = SessionsViewToPresenterProtocol & SessionsRouterToPresenterProtocol

final class SessionsPresenter: SessionsPresenterProtocol, EntityFetcher {
    weak var view: SessionsPresenterToViewProtocol!
    let interactor: SessionsPresenterToInteractorProtocol
    let router: SessionsPresenterToRouterProtocol
    
    init(interactor: SessionsPresenterToInteractorProtocol, router: SessionsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "workout == %@", self.interactor.workout)
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Session.day, ascending: true),
                                        NSSortDescriptor(keyPath: \Session.startsAt, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
}

// MARK: - ViewToPresenterProtocol
extension SessionsPresenter {
    var workoutName: String { interactor.workoutName }
    
    var sessionsCount: Int { entitiesCount }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(view)
        fetchEntities()
    }
    
    func addSessionTapped() { router.presentAddSessionForm() }
    
    func session(at indexPath: IndexPath) -> Session { entity(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) { deleteEntity(at: indexPath) }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.presentEditSessionForm(for: session(at: indexPath))
    }
}

// MARK: - RouterToPresenterProtocol
extension SessionsPresenter {
    func addCompletionAction(formOutput: SessionFormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
