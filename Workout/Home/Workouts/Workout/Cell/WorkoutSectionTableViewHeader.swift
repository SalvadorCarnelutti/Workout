//
//  WorkoutSectionsTableViewHeader.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//

import UIKit

protocol WorkoutSectionTableViewHeaderDelegate: AnyObject {
    func customHeaderViewDidTapSection(at section: WorkoutSection)
}

final class WorkoutSectionTableViewHeader: UITableViewHeaderFooterView {
    var section: WorkoutSection?
    weak var delegate: WorkoutSectionTableViewHeaderDelegate?
    
    private lazy var workoutContainer: UIView = {
        let view = UIView()
        view.addSubview(sectionNameLabel)
        view.addSubview(sectionImage)
        addSubview(view)
        return view
    }()
    
    private lazy var sectionNameLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var sectionImage: UIImageView = {
        let imageView = UIImageView()
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
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        sectionNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        sectionImage.snp.makeConstraints { make in
            make.left.equalTo(sectionNameLabel.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().offset(10)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }        
    }
    
    private func addGestureRecognizer() {
        let headerTapGesture = UITapGestureRecognizer(target: self, action:#selector(headerTapped))
        addGestureRecognizer(headerTapGesture)
    }
    
    @objc private func headerTapped() {
        guard let delegate = delegate, let section = section else { return }
        
        delegate.customHeaderViewDidTapSection(at: section)
    }
    
    func configure(with workoutSection: WorkoutSection) {
        section = workoutSection
        sectionNameLabel.text = workoutSection.name
        sectionImage.image = workoutSection.image
    }
}

