//
//  ValidatedTextField.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//

import UIKit

class ValidatedTextField: UITextField {
    // MARK: - Properties
    private(set) var isValid = false
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func configure(with entity: ValidationEntity) {
        validationBlock = entity.validationBlock
        errorMessage = entity.errorMessage
        errorColor = entity.errorColor
        placeholder = entity.placeholder
    }
    
    var unwrappedText: String {
        return text ?? ""
    }

    private func commonInit() {
        addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    // MARK: - Validation
    @objc private func textFieldEditingChanged() {
        validateInput()
    }

    private func validateInput() {
        isValid = validationBlock?(text) ?? true
        isValid ? resetErrorState() : showErrorState()
    }

    private func resetErrorState() {
        layer.borderWidth = 0
    }

    private func showErrorState() {
        layer.borderWidth = 1
        layer.borderColor = errorColor.cgColor
    }
}

struct ValidationEntity {
    var validationBlock: ((String?) -> Bool)?
    var errorMessage: String = "Invalid input"
    var errorColor: UIColor = UIColor.red
    var placeholder: String
}
