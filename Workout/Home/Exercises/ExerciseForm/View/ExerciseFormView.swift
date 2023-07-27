//
//  
//  ExerciseFormView.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import UIKit

protocol ExerciseFormViewDelegate: AnyObject {
    var nameEntity: ValidationEntity { get }
    var durationEntity: ValidationEntity { get }
    var setsEntity: ValidationEntity { get }
    var repsEntity: ValidationEntity { get }
    var isCompletionButtonEnabled: Bool { get }
    var headerString: String { get }
    var completionButtonString: String { get }
    func completionButtonTapped(for formOutput: ExerciseFormOutput)
    func viewLoaded()
}

final class ExerciseFormView: UIView {
    // MARK: - Properties
    weak var delegate: ExerciseFormViewDelegate?
    private var requiredFormFields = [ValidatedFormField]()
    private var optionalFormFields = [ValidatedFormField]()
    
    private lazy var verticalStack: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: [nameFormField, minutesDurationFormField, setsFormField, repsFormField])
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var headerLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .center
        label.text = delegate?.headerString
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var nameFormField: ValidatedFormField = {
        let formField = ValidatedFormField()
        addSubview(formField)
        return formField
    }()
    
    private lazy var minutesDurationFormField: ValidatedFormField = {
        let formField = ValidatedFormField(isOptional: true)
        addSubview(formField)
        formField.keyboardType = .numberPad
        return formField
    }()
    
    private lazy var setsFormField: ValidatedFormField = {
        let formField = ValidatedFormField()
        addSubview(formField)
        formField.keyboardType = .numberPad
        return formField
    }()
    
    private lazy var repsFormField: ValidatedFormField = {
        let formField = ValidatedFormField()
        addSubview(formField)
        formField.keyboardType = .numberPad
        return formField
    }()
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton()
        addSubview(button)
        button.isEnabled = delegate?.isCompletionButtonEnabled ?? false
        button.setTitle(delegate?.completionButtonString, for: .normal)
        button.addTarget(self, action: #selector(completionActionTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completionButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc private func completionActionTapped() {
        guard let sets = Int(setsFormField.unwrappedText),
              let reps = Int(repsFormField.unwrappedText) else {
            return
        }
        
        let duration = Int(minutesDurationFormField.unwrappedText)
        
        let formOutput = ExerciseFormOutput(name: nameFormField.unwrappedText,
                                            minutesDuration: duration,
                                            sets: sets,
                                            reps: reps)
        
        delegate?.completionButtonTapped(for: formOutput)
    }
    
    private func setupFormFields() {
        guard let delegate = delegate else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        nameFormField.configure(with: delegate.nameEntity)
        minutesDurationFormField.configure(with: delegate.durationEntity)
        setsFormField.configure(with: delegate.setsEntity)
        repsFormField.configure(with: delegate.repsEntity)
        
        requiredFormFields = [nameFormField,
                              setsFormField,
                              repsFormField]
        
        optionalFormFields = [minutesDurationFormField]
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            let areRequiredFormFieldsValid = self.requiredFormFields.map { $0.isValid }.allSatisfy { $0 }
            let areOptionalFormFieldsValid = self.optionalFormFields.map { $0.isValid }.allSatisfy { $0 }
            let allFormFieldsAreValid = areRequiredFormFieldsValid && areOptionalFormFieldsValid
            self.completionButton.isEnabled = allFormFieldsAreValid
        })
    }
}

extension ExerciseFormView {
    func loadView() {
        backgroundColor = .systemBackground
        setupFormFields()
        setupConstraints()
        delegate?.viewLoaded()
    }
    
    func fillFormFields(formInput: ExerciseFormInput) {
        nameFormField.text = formInput.name
        minutesDurationFormField.text = formInput.minutesDuration
        setsFormField.text = formInput.sets
        repsFormField.text = formInput.reps
        
        // isValid needs to be updated appropriately for each formField, we need to notify at beginning of edit
        requiredFormFields.forEach { $0.sendActions(for: .editingChanged) }
        optionalFormFields.forEach { $0.sendActions(for: .editingChanged) }
    }
}
