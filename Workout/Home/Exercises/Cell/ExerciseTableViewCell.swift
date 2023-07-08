//
//  ExerciseTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/4/23.
//

import UIKit

final class ExerciseTableViewCell: UITableViewCell {
    private lazy var stackView: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: [nameLabel, timeDurationLabel, setsLabel, repsLabel])
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var nameLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var timeDurationLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repsLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var setsLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var orderLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        
        // Set corner radius
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true

        // Set border color and width
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.borderWidth = 2.0
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
        orderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(orderLabel.snp.right).offset(8)
            make.top.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with exercise: Exercise) {
        nameLabel.text = exercise.name
        configureTimeDurationLabel(with: exercise.formattedDurationString)
        setsLabel.text = "• Set count: \(exercise.setsString)"
        repsLabel.text = "• Rep count: \(exercise.repsString)"
        orderLabel.text = "\(exercise.itemOrder)"
    }
    
    private func configureTimeDurationLabel(with text: String?) {
        if let text = text {
            timeDurationLabel.text = "• Duration: \(text)"
            timeDurationLabel.isHidden = false
        } else {
            timeDurationLabel.isHidden = true
        }
    }
}
