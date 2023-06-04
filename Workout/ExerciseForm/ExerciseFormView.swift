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
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.text = "Add exercise to current workout"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private lazy var exerciseNameTextField: ValidatedTextField = {
        let textField = ValidatedTextField()
        addSubview(textField)
        textField.placeholder = "Exercise name"
        textField.errorMessage = "Name can't be empty"
        textField.validationBlock = { text in
            return !text!.isEmpty
        }
        return textField
    }()
    
    private lazy var addButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.backgroundColor = .systemBlue
        addSubview(button)
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().offset(20)
        }
        
        exerciseNameTextField.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(exerciseNameTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension ExerciseFormView: ExerciseFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}

import UIKit

class StyledButton: UIButton {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        let width = titleSize.width + safeAreaInsets.left + safeAreaInsets.right
        let height = bounds.height
        return CGSize(width: width + 50, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
