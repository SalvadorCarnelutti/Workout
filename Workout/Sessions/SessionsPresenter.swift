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

// Will need this and Hor and minute formatted as date to represent cyclic train ing days
enum DayOfWeek: Int {
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
}

protocol SessionsViewToPresenterProtocol: UIViewController {
    var sessionsCount: Int { get }
    func viewLoaded()
    func sessionAt(indexPath: IndexPath) -> Session
    func deleteRowAt(indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
    func didDeleteRowAt(_ indexPath: IndexPath)
}

protocol SessionsRouterToPresenterProtocol: UIViewController {}

final class SessionsPresenter: BaseViewController {
    var viewSessions: SessionsPresenterToViewProtocol!
    var interactor: SessionsPresenterToInteractorProtocol!
    var router: SessionsPresenterToRouterProtocol!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "workout == %@", self.interactor.workout)
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicate
        // TODO: Check later if necessary to see that ordering is preserved
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Session.startsAt), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func loadView() {
        super.loadView()
        view = viewSessions
        viewSessions.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = interactor.workoutName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addSessionTapped))
    }
    
    @objc private func addSessionTapped() {
        router.presentAddSessionForm()
    }
    
    private func fetchExercises() {
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
extension SessionsPresenter: SessionsViewToPresenterProtocol {
    var sessionsCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewSessions
        fetchExercises()
    }
    
    func sessionAt(indexPath: IndexPath) -> Session {
        fetchedResultsController.object(at: indexPath)
    }
    
    func deleteRowAt(indexPath: IndexPath) {
        let session = sessionAt(indexPath: indexPath)
        session.managedObjectContext?.delete(session)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
    }
    
    func didDeleteRowAt(_ indexPath: IndexPath) {
        
    }
}

// MARK: - RouterToPresenterProtocol
extension SessionsPresenter: SessionsRouterToPresenterProtocol {}
