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
        label.text = "Add exercise to current workout"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private lazy var exerciseNameTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.placeholder = "Name"
        textField.errorMessage = "Name can't be empty"
        textField.validationBlock = ExerciseFormInteractor.nameValidationBlock
        return textField
    }()
    
    private lazy var exerciseDurationTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.placeholder = "Duration"
        textField.errorMessage = "Must be greater than zero"
        textField.validationBlock = ExerciseFormInteractor.durationValidationBlock
        return textField
    }()
    
    private lazy var exerciseSetsTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.placeholder = "Set count"
        textField.errorMessage = "Must be greater than zero"
        textField.validationBlock = ExerciseFormInteractor.durationValidationBlock
        return textField
    }()
    
    private lazy var exerciseRepsTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.placeholder = "Rep count"
        textField.errorMessage = "Must be greater than zero"
        textField.validationBlock = ExerciseFormInteractor.durationValidationBlock
        return textField
    }()
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton(type: .system)
        addSubview(button)
        button.isEnabled = false
        button.setTitle("Add", for: .normal)
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
    
    private func setupTextFields() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        textFields = [exerciseNameTextField,
                      exerciseDurationTextField,
                      exerciseSetsTextField,
                      exerciseRepsTextField]
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
        presenter?.viewLoaded()
    }
}
