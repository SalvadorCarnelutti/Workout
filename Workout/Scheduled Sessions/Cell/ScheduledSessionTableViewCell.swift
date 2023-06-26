//
//  ScheduledSessionTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/26/23.
//

import UIKit

final class ScheduledSessionTableViewCell: UITableViewCell {
    private lazy var stackView: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: [workoutNameLabel, startsAtLabel, exerciseCountLabel, durationTimeLabel])
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var workoutNameLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var startsAtLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var exerciseCountLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var durationTimeLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(with session: Session) {
        guard let workout = session.workout,
              let workoutName = workout.name else { return }
        
        workoutNameLabel.text = "\(workoutName):"
        startsAtLabel.text = "• \(session.formattedStartsAt)"
        exerciseCountLabel.text = "• \(workout.exercisesCount) exercise\(workout.exercisesCount > 1 ? "s" : "")"
        durationTimeLabel.text = "• Total duration: \(workout.duration) min"
    }
}
