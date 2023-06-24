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
}

protocol SessionFormRouterToPresenterProtocol: UIViewController {}

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
    var headerString: String {
        "Session"
    }
    
    var completionString: String {
//        interactor.formStyle == .add ? "Add" : "Edit"
        "Add"
    }
    
    func viewLoaded() {}
}

// MARK: - RouterToPresenterProtocol
extension SessionFormPresenter: SessionFormRouterToPresenterProtocol {}
