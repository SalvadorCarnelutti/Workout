//
//  DaySelectionView.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import UIKit

enum DaySelectionViewStyle {
    case normal
    case compact
}

final class DaySelectionView: UIView {
    private static let daysOfWeek: [DayOfWeek] = DayOfWeek.allCases
    private(set) var selectedDay: DayOfWeek?
    private let style: DaySelectionViewStyle
    
    private lazy var dayButtons: [UIButton] = {
        Self.daysOfWeek.map { getDayButton(for: $0) }
    }()
    
    private lazy var stackView: StackView = {
        let stackView = style == .normal ? VerticalStack() : HorizontalStack()
        addSubview(stackView)
        return stackView
    }()
    
    init(style: DaySelectionViewStyle) {
        self.style = style
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectDayOfWeek(_ dayOfWeek: DayOfWeek) {
        dayButtons[dayOfWeek.rawValue].sendActions(for: .touchUpInside)
    }
    
    private func getDayButton(for day: DayOfWeek) -> UIButton {
        let dayDescription = style == .normal ? day.longDescription : day.compactDescription
        var configuration = UIButton.Configuration.gray()
        configuration.attributedTitle = AttributedString(dayDescription, attributes: AttributeContainer([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ]))

        var selectedConfiguration = configuration
        selectedConfiguration.attributedTitle = AttributedString(dayDescription, attributes: AttributeContainer([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ]))
        
        let dayButton = UIButton(configuration: configuration)
        dayButton.tag = day.rawValue

        dayButton.configurationUpdateHandler = { button in
            button.configuration = button.isSelected ? selectedConfiguration : configuration
        }
        
        if style == .compact {
            dayButton.snp.makeConstraints { make in
                make.width.equalTo(dayButton.snp.height)
            }
        }
        
        dayButton.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        
        return dayButton
    }
    
    private func selectCurrentDay() {
        let currentDayButton = dayButtons[Date.weekday]
        currentDayButton.sendActions(for: .touchUpInside)
    }
    
    private func setupViews() {
        dayButtons.forEach { stackView.addArrangedSubview($0) }
        selectCurrentDay()
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard sender.tag != selectedDay?.rawValue else { return }

        selectedDay = DayOfWeek(rawValue: sender.tag)
        for button in dayButtons {
            button.isSelected = button.tag == sender.tag
        }
    }
}
