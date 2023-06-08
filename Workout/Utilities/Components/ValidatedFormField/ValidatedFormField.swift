//
//  ValidatedFormField.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit
import SnapKit

protocol ValidatedTextFieldDelegate: AnyObject {
    func onValidChange(newValue: Bool)
}
class ValidatedFormField: UIView {
    // MARK: - Properties
    private let errorColor: UIColor = UIColor.red.withAlphaComponent(0.65)
    private var errorMessage: String?
    
    lazy var validatedTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        return textField
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.textColor = errorColor
        label.text = errorMessage
        label.alpha = 0
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var isValid: Bool {
        validatedTextField.isValid
    }
    
    var unwrappedText: String {
        validatedTextField.unwrappedText
    }
    
    var text: String? {
        get {
            validatedTextField.text
        }
        set(newText) {
            validatedTextField.text = newText
        }
    }
    
    var keyboardType: UIKeyboardType {
        get {
            validatedTextField.keyboardType
        }
        set(newKeyboardTypr) {
            validatedTextField.keyboardType = newKeyboardTypr
        }
    }
    
    func configure(with entity: ValidationEntity) {
        validatedTextField.configure(with: entity)
        validatedTextField.validatedTextFieldDelegate = self
        errorMessageLabel.text = entity.errorMessage
    }
    
    func sendActions(for controlEvents: UIControl.Event) {
        validatedTextField.sendActions(for: controlEvents)
    }
    
    private func commonInit() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        validatedTextField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        errorMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(validatedTextField.snp.bottom).offset(2)
            make.bottom.equalToSuperview().inset(5)
        }
    }
}

extension ValidatedFormField: ValidatedTextFieldDelegate {
    func onValidChange(newValue: Bool) {
        UIView.animate(withDuration: 0.15, animations: {
            self.errorMessageLabel.alpha = newValue ? 0 : 1
        })
    }
}
