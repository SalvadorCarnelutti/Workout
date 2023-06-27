//
//  
//  ScheduledSessionFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import CoreData

protocol ScheduledSessionFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormInteractor: ScheduledSessionFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
//    private let session: Session
//    
//    init(session: Session) {
//        self.session = session
//    }
}
