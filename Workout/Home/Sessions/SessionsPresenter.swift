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
    
    init(interactor: SessionsPresenterToInteractorProtocol, router: SessionsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
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
