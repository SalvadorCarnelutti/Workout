//
//  ActivityIndicator.swift
//  Workout
//
//  Created by Salvador on 6/9/23.
//

import UIKit

class ActivityIndicator: UIView {
    private struct Constants {
        static let ActivityIndicatorSize: CGFloat = 40
        static let CornerRadius: CGFloat = 16
        static let BackgroundLoadingViewColor: UIColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        static let MainContainerAlpha: CGFloat = 0.9
        static let MainContainerColor: UIColor = .white
    }
    
    private lazy var mainContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.MainContainerColor
        view.alpha = Constants.MainContainerAlpha
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.CornerRadius
        view.isHidden = true
        
        return view
    }()
    
    private lazy var backgroundLoadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.CornerRadius
        view.backgroundColor = Constants.BackgroundLoadingViewColor
        
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        bringSubviewToFront(mainContainer)
        mainContainer.isHidden = false
        backgroundLoadingView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        mainContainer.isHidden = true
        backgroundLoadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func setupViews() {
        addSubview(mainContainer)
        isUserInteractionEnabled = false
        mainContainer.addSubview(backgroundLoadingView)
        backgroundLoadingView.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
    }
    
    private func setupConstraints() {
        mainContainer.pinToSuperview()
        backgroundLoadingView.pinToSuperview()
        activityIndicator.centerInSuperview()
        activityIndicator.constraintSizeWithEqualSides(Constants.ActivityIndicatorSize)
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
