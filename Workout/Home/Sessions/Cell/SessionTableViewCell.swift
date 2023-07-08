//
//  SessionTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import UIKit

final class SessionTableViewCell: UITableViewCell {
    private lazy var stackView: VerticalStack = {
       let stackView = VerticalStack(arrangedSubviews: [dayLabel, startsAtLabel])
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var dayLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var startsAtLabel: MultilineLabel = {
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
        guard let dayString = DayOfWeek(rawValue: Int(session.weekday))?.longDescription else { return }
        
        dayLabel.text = "\(dayString):"
        startsAtLabel.text = session.formattedStartsAt
    }
}
