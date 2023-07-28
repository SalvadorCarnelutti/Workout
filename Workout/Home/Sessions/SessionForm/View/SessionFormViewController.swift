//
//  SessionFormViewController.swift
//  Workout
//
//  Created by Salvador on 7/27/23.
//

import UIKit

protocol SessionFormPresenterToViewProtocol: AnyObject {
    func loadView()
    func setDefaultDisplay()
    func fillSessionFields(with sessionFormInput: SessionFormInput)
}

final class SessionFormViewController: BaseViewController {
    let presenter: SessionFormViewToPresenterProtocol
    let sessionFormView = SessionFormView()
    
    init(presenter: SessionFormViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = sessionFormView
        setupViews()
    }
    
    private func setupViews() {
        sessionFormView.delegate = self
        sessionFormView.loadView()
    }
}

extension SessionFormViewController: SessionFormPresenterToViewProtocol {
    func setDefaultDisplay() {
        sessionFormView.setDefaultDisplay()
    }
    
    func fillSessionFields(with sessionFormInput: SessionFormInput) {
        sessionFormView.fillSessionFields(with: sessionFormInput)
    }
}

// MARK: - SessionFormViewDelegate
extension SessionFormViewController: SessionFormViewDelegate {
    var headerString: String { presenter.headerString }
    
    var completionString: String { presenter.completionString }
    
    func viewLoaded() { presenter.viewLoaded() }
    
    func completionButtonTapped(for formOutput: SessionFormOutput) {
        presenter.completionButtonTapped(for: formOutput)
    }
}
