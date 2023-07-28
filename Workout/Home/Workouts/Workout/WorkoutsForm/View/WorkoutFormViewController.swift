//
//  WorkoutFormViewController.swift
//  Workout
//
//  Created by Salvador on 7/27/23.
//

import UIKit

protocol WorkoutsFormPresenterToViewProtocol: AnyObject {
    func loadView()
    func fillFormField(formInput: String)
}

final class WorkoutFormViewController: BaseViewController {
    // MARK: - Properties
    let presenter: WorkoutFormViewToPresenterProtocol
    let workoutFormView = WorkoutFormView()
    
    init(presenter: WorkoutFormViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = workoutFormView
        setupViews()
    }
    
    private func setupViews() {
        workoutFormView.delegate = self
        workoutFormView.loadView()
    }
}

// MARK: - PresenterToViewProtocol
extension WorkoutFormViewController: WorkoutsFormPresenterToViewProtocol {
    func fillFormField(formInput: String) {
        workoutFormView.fillFormField(formInput: formInput)
    }
}

// MARK: - WorkoutFormViewDelegate
extension WorkoutFormViewController: WorkoutFormViewDelegate {
    var nameEntity: ValidationEntity { presenter.nameEntity }
    
    var isButtonEnabled: Bool { presenter.isButtonEnabled }
    
    var headerString: String { presenter.headerString }
    
    var completionString: String { presenter.completionString }
    
    func viewLoaded() { presenter.viewLoaded() }
    
    func completionButtonTapped(for string: String) { presenter.completionButtonTapped(for: string) }
}
