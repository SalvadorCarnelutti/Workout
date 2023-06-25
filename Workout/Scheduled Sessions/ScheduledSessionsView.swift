//
//  
//  ScheduledSessionsView.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import UIKit

protocol ScheduledSessionsPresenterToViewProtocol: UIView {
    var presenter: ScheduledSessionsViewToPresenterProtocol? { get set }
    func loadView()
}

final class ScheduledSessionsView: UIView {
    // MARK: - Properties
    weak var presenter: ScheduledSessionsViewToPresenterProtocol?
    
    private func setupConstraints() {
        
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionsView: ScheduledSessionsPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}
