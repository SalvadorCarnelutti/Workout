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
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
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
    var headerString: String { String(localized: "Session") }
    
    var completionString: String {
        interactor.formStyle == .add ? String(localized: "Add") : String(localized: "Edit")
    }
    
    func viewLoaded() {
        if let sessionFormInput = interactor.formInput {
            viewSessionForm.fillSessionFields(with: sessionFormInput)
        } else {
            viewSessionForm.setDefaultDisplay()
        }
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
