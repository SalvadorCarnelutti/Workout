//
//  ValidatedTextField.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//

import UIKit

class ValidatedTextField: UITextField {
    // MARK: - Properties
    var validationBlock: ((String?) -> Bool)?
    var errorMessage: String = "Invalid input"
    var errorColor: UIColor = UIColor.red

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    // MARK: - Validation
    @objc private func textFieldEditingChanged() {
        validateInput()
    }

    func validateInput() {
        let isValid = validationBlock?(text) ?? true
        if isValid {
            resetErrorState()
        } else {
            showErrorState()
        }
    }

    private func resetErrorState() {
        layer.borderWidth = 0
    }

    private func showErrorState() {
        layer.borderWidth = 1
        layer.borderColor = errorColor.cgColor
    }
}
