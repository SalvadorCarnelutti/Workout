//
//  
//  SessionFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//

import UIKit

protocol SessionFormViewToPresenterProtocol: AnyObject {
    var view: SessionFormPresenterToViewProtocol! { get set }
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
    func completionButtonTapped(for formOutput: SessionFormOutput)
}

protocol SessionFormRouterToPresenterProtocol: AnyObject {
    func completionAction(for formOutput: SessionFormOutput)
}

typealias SessionFormPresenterProtocol = SessionFormViewToPresenterProtocol & SessionFormRouterToPresenterProtocol

final class SessionFormPresenter: SessionFormPresenterProtocol {
    weak var view: SessionFormPresenterToViewProtocol!
    let interactor: SessionFormPresenterToInteractorProtocol
    let router: SessionFormPresenterToRouterProtocol
    
    init(interactor: SessionFormPresenterToInteractorProtocol, router: SessionFormPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
}

// MARK: - ViewToPresenterProtocol
extension SessionFormPresenter {
    var headerString: String { String(localized: "Session") }
    
    var completionString: String {
        interactor.formStyle == .add ? String(localized: "Add") : String(localized: "Edit")
    }
    
    func viewLoaded() {
        if let sessionFormInput = interactor.formInput {
            view.fillSessionFields(with: sessionFormInput)
        } else {
            view.setDefaultDisplay()
        }
    }
        
    func completionButtonTapped(for formOutput: SessionFormOutput) {
        router.dismissView(formOutput: formOutput)
    }
}

// MARK: - RouterToPresenterProtocol
extension SessionFormPresenter {
    func completionAction(for formOutput: SessionFormOutput) {
        interactor.completionAction(formOutput)
    }
}
