//
//  
//  ExerciseFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit

protocol ExerciseFormViewToPresenterProtocol: UIViewController {
    func viewLoaded()
}

final class ExerciseFormPresenter: BaseViewController {
    var viewExerciseForm: ExerciseFormPresenterToViewProtocol!
    var interactor: ExerciseFormPresenterToInteractorProtocol!
    var router: ExerciseFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewExerciseForm
        viewExerciseForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension ExerciseFormPresenter: ExerciseFormViewToPresenterProtocol {
    func viewLoaded() {}
}
