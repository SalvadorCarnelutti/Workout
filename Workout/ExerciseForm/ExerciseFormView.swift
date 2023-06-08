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
    private var textFields = [ValidatedTextField]()
    
    private lazy var stackView: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: textFields)
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.text = presenter?.headerString
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private lazy var nameTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        return textField
    }()
    
    private lazy var durationTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var setsTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var repsTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.keyboardType = .numberPad
        return textField
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
            make.horizontalEdges.equalToSuperview().offset(20)
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
        guard let duration = Int(durationTextField.unwrappedText),
              let sets = Int(setsTextField.unwrappedText),
              let reps = Int(repsTextField.unwrappedText) else {
            return
        }
        
        let formOutput = FormOutput(name: nameTextField.unwrappedText,
                                    duration: duration,
                                    sets: sets,
                                    reps: reps)
        
        presenter?.completionAction(for: formOutput)
    }
    
    private func setupTextFields() {
        guard let presenter = presenter else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        nameTextField.configure(with: presenter.nameEntity)
        durationTextField.configure(with: presenter.durationEntity)
        setsTextField.configure(with: presenter.setsEntity)
        repsTextField.configure(with: presenter.repsEntity)
        
        textFields = [nameTextField,
                      durationTextField,
                      setsTextField,
                      repsTextField]
        
        if let formInput = presenter.formInput {
            fillTextfields(formInput: formInput)
        }
    }
    
    private func fillTextfields(formInput: FormInput) {
        nameTextField.text = formInput.name
        durationTextField.text = formInput.duration
        setsTextField.text = formInput.sets
        repsTextField.text = formInput.reps
        
        // isValid needs to be updated appropriately for each textField, we need to notify at beginning of edit
        textFields.forEach { $0.sendActions(for: .editingChanged) }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        completionButton.isEnabled = textFields.map { $0.isValid }.allSatisfy { $0 }
    }
}

// MARK: - PresenterToViewProtocol
extension ExerciseFormView: ExerciseFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupTextFields()
        setupConstraints()
    }
}
