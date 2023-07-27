//
//  ExerciseFormViewController.swift
//  Workout
//
//  Created by Salvador on 7/26/23.
//

import UIKit

protocol ExerciseFormPresenterToViewProtocol: AnyObject {
    var presenter: ExerciseFormViewToPresenterProtocol { get }
    func fillFormFields(formInput: ExerciseFormInput)
}

final class ExerciseFormViewController: BaseViewController {
    // MARK: - Properties
    let presenter: ExerciseFormViewToPresenterProtocol
    let exerciseFormView = ExerciseFormView()
    
    init(presenter: ExerciseFormViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = exerciseFormView
        setupViews()
    }
    
    private func setupViews() {
        exerciseFormView.delegate = self
        exerciseFormView.loadView()
    }
}

// MARK: - PresenterToViewProtocol
extension ExerciseFormViewController: ExerciseFormPresenterToViewProtocol {
    func fillFormFields(formInput: ExerciseFormInput) {
        exerciseFormView.fillFormFields(formInput: formInput)
    }
}

// MARK: - ExerciseFormViewDelegate
extension ExerciseFormViewController: ExerciseFormViewDelegate {
    var nameEntity: ValidationEntity { presenter.nameEntity }
    
    var durationEntity: ValidationEntity { presenter.durationEntity }
    
    var setsEntity: ValidationEntity { presenter.setsEntity }
    
    var repsEntity: ValidationEntity { presenter.setsEntity }
    
    var isCompletionButtonEnabled: Bool { presenter.isCompletionButtonEnabled }
    
    var headerString: String { presenter.headerString }
    
    var completionButtonString: String { presenter.completionButtonString }
    
    func completionButtonTapped(for formOutput: ExerciseFormOutput) {
        presenter.completionButtonTapped(for: formOutput)
    }
    
    func viewLoaded() { presenter.viewLoaded() }
}
