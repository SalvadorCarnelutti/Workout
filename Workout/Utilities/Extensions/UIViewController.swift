//
//  UIViewController.swift
//  Workout
//
//  Created by Salvador on 7/6/23.
//

import UIKit

extension UIViewController {
    func clearContentUnavailableConfiguration() {
        contentUnavailableConfiguration = nil
    }
    
    private func configureContentUnavailableConfiguration(config: UIContentUnavailableConfiguration,
                                                          image: UIImage,
                                                          text: String,
                                                          secondaryText: String) {
        var newConfig = config
        newConfig.image = image
        newConfig.text = text
        newConfig.secondaryText = secondaryText
        newConfig.imageProperties.tintColor = .mainTheme
        contentUnavailableConfiguration = newConfig
    }
    
    func configureEmptyContentUnavailableConfiguration(image: UIImage,
                                                       text: String,
                                                       secondaryText: String) {
        configureContentUnavailableConfiguration(config: .empty(),
                                                 image: image,
                                                 text: text,
                                                 secondaryText: secondaryText)
    }
}
