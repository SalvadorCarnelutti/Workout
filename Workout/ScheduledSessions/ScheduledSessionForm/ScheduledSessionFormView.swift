//
//  
//  ScheduledSessionFormView.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import UIKit

protocol ScheduledSessionFormPresenterToViewProtocol: UIView {
    var presenter: ScheduledSessionFormViewToPresenterProtocol? { get set }
    func loadView()
}

final class ScheduledSessionFormView: UIView {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormViewToPresenterProtocol?
    
    private func setupConstraints() {
        
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionFormView: ScheduledSessionFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}
