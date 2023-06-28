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

protocol ScheduledSessionsViewToPresenterProtocol: UIViewController {
    var sessionsCount: Int { get }
    func viewLoaded()
    func didSelectDay(at: Int)
    func session(at indexPath: IndexPath) -> Session
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol ScheduledSessionsRouterToPresenterProtocol: UIViewController {
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

final class ScheduledSessionsPresenter: BaseViewController, EntityFetcher {
    var viewScheduledSessions: ScheduledSessionsPresenterToViewProtocol!
    var interactor: ScheduledSessionsPresenterToInteractorProtocol!
    var router: ScheduledSessionsPresenterToRouterProtocol!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: self.viewScheduledSessions.selectedDay))
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
    
    // Because NSFetchedResultsController only tracks changes to its non relationship attributes, we must consider Workout's exercises count and time duration updates
    // This could be really inefficient if we had to update large volumes of data in a table view, but for this app's usage it's fine
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewScheduledSessions.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessions
        viewScheduledSessions.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Scheduled Sessions"
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsViewToPresenterProtocol {
    var sessionsCount: Int {
        entitiesCount
    }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewScheduledSessions
        fetchEntities()
    }
    
    func didSelectDay(at: Int) {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: at))
        setFetchRequestPredicate(predicate)
        fetchEntities()
        viewScheduledSessions.reloadData()
    }
    
    func session(at indexPath: IndexPath) -> Session {
        entity(at: indexPath)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        deleteEntity(at: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.pushEditSessionForm(for: session(at: indexPath))
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsRouterToPresenterProtocol {
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
