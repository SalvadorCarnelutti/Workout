//
//  
//  ExerciseFormView.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import UIKit
import SnapKit

protocol ExerciseFormPresenterToViewProtocol: UIView {
    var presenter: ExerciseFormViewToPresenterProtocol? { get set }
    func loadView()
}

final class ExerciseFormView: UIView {
    // MARK: - Properties
    weak var presenter: ExerciseFormViewToPresenterProtocol?
    private var formFields = [ValidatedFormField]()
    
    private lazy var stackView: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: formFields)
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var headerLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .center
        label.text = presenter?.headerString
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var nameFormField: ValidatedFormField = {
        let formField = ValidatedFormField()
        addSubview(formField)
        return formField
    }()
    
    private lazy var durationFormField: ValidatedFormField = {
        let formField = ValidatedFormField()
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
        let button = StyledButton(type: .system)
        addSubview(button)
        button.isEnabled = presenter?.isbuttonEnabled ?? false
        button.setTitle(presenter?.completionString, for: .normal)
        button.addTarget(self, action: #selector(completionActionTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc private func completionActionTapped() {
        guard let duration = Int(durationFormField.unwrappedText),
              let sets = Int(setsFormField.unwrappedText),
              let reps = Int(repsFormField.unwrappedText) else {
            return
        }
        
        let formOutput = FormOutput(name: nameFormField.unwrappedText,
                                    duration: duration,
                                    sets: sets,
                                    reps: reps)
        
        presenter?.completionButtonTapped(for: formOutput)
    }
    
    private func setupFormFields() {
        guard let presenter = presenter else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        nameFormField.configure(with: presenter.nameEntity)
        durationFormField.configure(with: presenter.durationEntity)
        setsFormField.configure(with: presenter.setsEntity)
        repsFormField.configure(with: presenter.repsEntity)
        
        formFields = [nameFormField,
                      durationFormField,
                      setsFormField,
                      repsFormField]
        
        if let formInput = presenter.formInput {
            fillFormFields(formInput: formInput)
        }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.completionButton.isEnabled = self.formFields.map { $0.isValid }.allSatisfy { $0 }
        })
    }
    
    private func fillFormFields(formInput: FormInput) {
        nameFormField.text = formInput.name
        durationFormField.text = formInput.duration
        setsFormField.text = formInput.sets
        repsFormField.text = formInput.reps
        
        // isValid needs to be updated appropriately for each formField, we need to notify at beginning of edit
        formFields.forEach { $0.sendActions(for: .editingChanged) }
    }
}

// MARK: - PresenterToViewProtocol
extension ExerciseFormView: ExerciseFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupFormFields()
        setupConstraints()
    }
}
