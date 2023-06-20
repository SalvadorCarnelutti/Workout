//
//  ExerciseTableViewHeader.swift
//  Workout
//
//  Created by Salvador on 6/12/23.
//

import UIKit

protocol ExerciseTableViewHeaderDelegate: AnyObject {
    func customHeaderViewDidTap()
//    func completionButtonTapped(for newName: String)
}

final class ExerciseTableViewHeader: UITableViewHeaderFooterView {
    weak var delegate: ExerciseTableViewHeaderDelegate?
    
    private lazy var workoutContainer: UIView = {
        let view = UIView()
        view.addSubview(workoutNameLabel)
        view.addSubview(editWorkoutNameImage)
        addSubview(view)
        return view
    }()
    
    private lazy var workoutNameLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var editWorkoutNameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .edit
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        workoutContainer.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        workoutNameLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(workoutContainer)
        }
        
        editWorkoutNameImage.snp.makeConstraints { make in
            make.left.equalTo(workoutNameLabel.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview()
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
    
    private func addGestureRecognizer() {
        let labelTapGesture = UITapGestureRecognizer(target: self, action:#selector(headerTapped))
        addGestureRecognizer(labelTapGesture)
    }
    
    @objc private func headerTapped() {
        delegate?.customHeaderViewDidTap()
    }
    
    func configure(with name: String) {
        workoutNameLabel.text = name
    }
}

