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

final class ScheduledSessionsPresenter: BaseViewController {
    var viewScheduledSessions: ScheduledSessionsPresenterToViewProtocol!
    var interactor: ScheduledSessionsPresenterToInteractorProtocol!
    var router: ScheduledSessionsPresenterToRouterProtocol!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: self.viewScheduledSessions.selectedDay))
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Session.day), ascending: true),
                                        NSSortDescriptor(key: #keyPath(Session.startsAt), ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessions
        viewScheduledSessions.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Scheduled Sessions"
    }
    
    // TODO: Maybe add extension for all the fetches that do the same
    private func fetchSessions() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // TODO: Maybe a modal error meesage
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsViewToPresenterProtocol {
    var sessionsCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewScheduledSessions
        fetchSessions()
    }
    
    func didSelectDay(at: Int) {
        let predicate = NSPredicate(format: "day == %@", NSNumber(value: at))
        fetchedResultsController.fetchRequest.predicate = predicate
        fetchSessions()
        viewScheduledSessions.reloadData()
    }
    
    func session(at indexPath: IndexPath) -> Session {
        fetchedResultsController.object(at: indexPath)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        let session = session(at: indexPath)
        session.managedObjectContext?.delete(session)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.presentEditSessionForm(for: fetchedResultsController.object(at: indexPath))
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsRouterToPresenterProtocol {
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
