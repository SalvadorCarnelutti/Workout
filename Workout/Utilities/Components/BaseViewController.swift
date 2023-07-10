//
//  BaseViewController.swift
//  Workout
//
//  Created by Salvador on 6/9/23.
//

import UIKit

protocol BaseViewProtocol: UIViewController {
    func showLoader()
    func hideLoader()
    func presentOKAlert(title: String, message: String)
    func presentErrorMessage()
}

class BaseViewController: UIViewController, BaseViewProtocol {
    private struct Constraints {
        static let ActivityIndicatorSize: CGFloat = 80
    }
    
    private lazy var activityIndicator: ActivityIndicator = {
        let activityIndicator = ActivityIndicator()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBarAppearance()
    }
    
    func showLoader() {
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        view.sendSubviewToBack(activityIndicator)
        activityIndicator.stopAnimating()
    }
    
    func presentOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentErrorMessage() {
        presentOKAlert(title: "Unexpected error occured", message: "There was an error loading your information")
    }
    
    private func setupViews() {
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        activityIndicator.centerInSuperview()
        activityIndicator.constraintSizeWithEqualSides(Constraints.ActivityIndicatorSize)
    }
    
    private func setupNavigationBarAppearance() {
        // Make the navigation bar's black with white text.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainTheme
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.
        navigationController?.navigationBar.tintColor = .black // For navigationBar button items
    }
}

fileprivate extension UIView {
    func pinToSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    func centerInSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func constraintSizeWithEqualSides(_ size: CGFloat) {
        constraintSize(CGSize(width: size, height: size))
    }
    
    func constraintSize(_ size: CGSize) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
}
