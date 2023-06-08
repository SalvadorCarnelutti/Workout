//
//  WorkoutTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit

final class WorkoutTableViewCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.font = .systemFont(ofSize: 24, weight: .bold)
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
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(with workout: Workout) {
        nameLabel.text = workout.name
    }
}
