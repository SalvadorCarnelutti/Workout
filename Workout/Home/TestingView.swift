//
//  
//  TestingView.swift
//  Workout
//
//  Created by Salvador on 5/31/23.
//
//
import UIKit

protocol TestingPresenterToViewProtocol: UIView {
    var presenter: TestingViewToPresenterProtocol? { get set }
    func loadView()
}

final class TestingView: UIView {
    // MARK: - Properties
    weak var presenter: TestingViewToPresenterProtocol?
    
    private func setupConstraints() {
        
    }
}

// MARK: - PresenterToViewProtocol
extension TestingView: TestingPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}
