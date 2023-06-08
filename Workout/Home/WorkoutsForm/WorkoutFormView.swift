//
//  
//  WorkoutFormView.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//
import UIKit

protocol WorkoutsFormPresenterToViewProtocol: UIView {
    var presenter: WorkoutFormViewToPresenterProtocol? { get set }
    func loadView()
}

final class WorkoutFormView: UIView {
    // MARK: - Properties
    weak var presenter: WorkoutFormViewToPresenterProtocol?
    
    private lazy var headerLabel: UILabel = {
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
        
        nameFormField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(nameFormField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc private func completionActionTapped() {
        presenter?.completionAction(for: nameFormField.unwrappedText)
    }
    
    private func setupFormField() {
        guard let presenter = presenter else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        nameFormField.configure(with: presenter.nameEntity)
        
        if let formInput = presenter.formInput {
            fillFormField(formInput: formInput)
        }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        completionButton.isEnabled = nameFormField.isValid
    }
    
    private func fillFormField(formInput: String) {
        nameFormField.text = formInput
        
        // isValid needs to be updated appropriately for nameFormField, we need to notify at beginning of edit
        nameFormField.sendActions(for: .editingChanged)
    }
}

// MARK: - PresenterToViewProtocol
extension WorkoutFormView: WorkoutsFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupFormField()
        setupConstraints()
    }
}
