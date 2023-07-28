//
//  
//  WorkoutFormView.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//
import UIKit

protocol WorkoutFormViewDelegate: AnyObject {
    var nameEntity: ValidationEntity { get }
    var isButtonEnabled: Bool { get }
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
    func completionButtonTapped(for string: String)
}

final class WorkoutFormView: UIView {
    // MARK: - Properties
    weak var delegate: WorkoutFormViewDelegate?
    
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
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton()
        addSubview(button)
        button.isEnabled = delegate?.isButtonEnabled ?? false
        button.setTitle(delegate?.completionString, for: .normal)
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
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc private func completionActionTapped() {
        delegate?.completionButtonTapped(for: nameFormField.unwrappedText)
    }
    
    private func setupFormField() {
        guard let delegate = delegate else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        nameFormField.configure(with: delegate.nameEntity)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        completionButton.isEnabled = nameFormField.isValid
    }
}

extension WorkoutFormView {
    func loadView() {
        backgroundColor = .systemBackground
        setupFormField()
        setupConstraints()
        delegate?.viewLoaded()
    }
    
    func fillFormField(formInput: String) {
        nameFormField.text = formInput
        
        // isValid needs to be updated appropriately for nameFormField, we need to notify at beginning of edit
        nameFormField.sendActions(for: .editingChanged)
    }
}
