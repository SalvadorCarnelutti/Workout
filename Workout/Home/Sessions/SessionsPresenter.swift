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
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .sunday
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        default: return nil
        }
    }
    
    var longDescription: String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
}

protocol SessionsViewToPresenterProtocol: UIViewController {
    var sessionsCount: Int { get }
    func viewLoaded()
    func session(at indexPath: IndexPath) -> Session
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol SessionsRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(formOutput: SessionFormOutput)
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

final class SessionsPresenter: BaseViewController {
    var viewSessions: SessionsPresenterToViewProtocol!
    var interactor: SessionsPresenterToInteractorProtocol!
    var router: SessionsPresenterToRouterProtocol!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        let predicate = NSPredicate(format: "workout == %@", self.interactor.workout)
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicate
        // TODO: Check later if necessary to see that ordering is preserved
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
extension SessionsPresenter: SessionsRouterToPresenterProtocol {
    func addCompletionAction(formOutput: SessionFormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
