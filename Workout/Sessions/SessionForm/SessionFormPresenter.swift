//
//  
//  SessionFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//

import UIKit

protocol SessionFormViewToPresenterProtocol: UIViewController {
    var formInput: SessionFormInput? { get }
    var headerString: String { get }
    var completionString: String { get }
    func completionButtonTapped(for formOutput: SessionFormOutput)
}

protocol SessionFormRouterToPresenterProtocol: UIViewController {
    func completionAction(for formOutput: SessionFormOutput)
}

final class SessionFormPresenter: BaseViewController {
    var viewSessionForm: SessionFormPresenterToViewProtocol!
    var interactor: SessionFormPresenterToInteractorProtocol!
    var router: SessionFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewSessionForm
        viewSessionForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension SessionFormPresenter: SessionFormViewToPresenterProtocol {
    var formInput: SessionFormInput? {
        interactor.formInput
    }
    
    var headerString: String {
        "Session"
    }
    
    var completionString: String {
        interactor.formStyle == .add ? "Add" : "Edit"
    }
        
    func completionButtonTapped(for formOutput: SessionFormOutput) {
        router.dismissView(formOutput: formOutput)
    }
}

// MARK: - RouterToPresenterProtocol
extension SessionFormPresenter: SessionFormRouterToPresenterProtocol {
    func completionAction(for formOutput: SessionFormOutput) {
        interactor.completionAction(formOutput)
    }
}
