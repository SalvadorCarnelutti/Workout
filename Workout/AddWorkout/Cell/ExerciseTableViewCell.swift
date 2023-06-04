//
//  ExerciseTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/4/23.
//

import UIKit

final class ExerciseTableViewCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [nameLabel, durationLabel, repsLabel, setsLabel])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var setsLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstrains() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(with exercise: Exercise) {
        nameLabel.text = exercise.name
        durationLabel.text = "• Duration: \(exercise.durationString) min"
        repsLabel.text = "• Reps: \(exercise.repsString)"
        setsLabel.text = "• Sets: \(exercise.setsString)"
    }
}
