//
//  
//  ScheduledSessionsPresenter.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//

import UIKit
import CoreData

protocol ScheduledSessionsViewToPresenterProtocol: AnyObject {
    var view: ScheduledSessionsPresenterToViewProtocol! { get set }
    var sessionsCount: Int { get }
    func viewLoaded()
    func didSelect(day: Int)
    func session(at indexPath: IndexPath) -> Session
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol ScheduledSessionsRouterToPresenterProtocol: AnyObject {
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

typealias ScheduledSessionsPresenterProtocol = ScheduledSessionsViewToPresenterProtocol & ScheduledSessionsRouterToPresenterProtocol

final class ScheduledSessionsPresenter: ScheduledSessionsPresenterProtocol, EntityFetcher {
    weak var view: ScheduledSessionsPresenterToViewProtocol!
    let interactor: ScheduledSessionsPresenterToInteractorProtocol
    let router: ScheduledSessionsPresenterToRouterProtocol
    
    lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: self.view.selectedWeekday))
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
    
    init(interactor: ScheduledSessionsPresenterToInteractorProtocol, router: ScheduledSessionsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionsPresenter {
    var sessionsCount: Int { entitiesCount }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(view.fetchedResultsControllerDelegate)
        fetchEntities()
    }
    
    func didSelect(day: Int) {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: day))
        setFetchRequestPredicate(predicate)
        fetchEntities()
        view.reloadData()
    }
    
    func session(at indexPath: IndexPath) -> Session { entity(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) { deleteEntity(at: indexPath) }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.pushEditSessionForm(for: session(at: indexPath))
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionsPresenter {
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
