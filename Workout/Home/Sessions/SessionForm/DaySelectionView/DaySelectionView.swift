//
//  DaySelectionView.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import UIKit

final class DaySelectionView: UIView {
    private(set) var selectedDay: DayOfWeek?
    
    private let daysOfWeek = DayOfWeek.allCases.map { $0.longDescription }
    
    private lazy var dayButtons: [UIButton] = {
        daysOfWeek.map { getDayButton(for: $0) }
    }()
    
    private lazy var verticalStack: VerticalStack = {
        let verticalStack = VerticalStack()
        addSubview(verticalStack)
        return verticalStack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func selectDayOfWeek(_ dayOfWeek: DayOfWeek) {
        dayButtons[dayOfWeek.rawValue].sendActions(for: .touchUpInside)
    }
    
    private func getDayButton(for day: String) -> UIButton {
        var configuration = UIButton.Configuration.gray()
        configuration.attributedTitle = AttributedString(day, attributes: AttributeContainer([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ]))

        var selectedConfiguration = configuration
        selectedConfiguration.attributedTitle = AttributedString(day, attributes: AttributeContainer([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ]))
        
        let dayButton = UIButton(configuration: configuration)

        dayButton.configurationUpdateHandler = { button in
            button.configuration = button.isSelected ? selectedConfiguration : configuration
        }
        
        dayButton.setTitle(day, for: .normal)
        dayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        
        return dayButton
    }
    
    private func selectCurrentDay() {
        let calendar = Calendar.current
        let today = Date()

        let weekday = calendar.component(.weekday, from: today)

        // Adjust the weekday value to be in the range 0-6
        let adjustedWeekday = (weekday - calendar.firstWeekday + 7) % 7
        
        let currentDayButton = dayButtons[adjustedWeekday]
        currentDayButton.sendActions(for: .touchUpInside)
    }
    
    private func setupViews() {
        dayButtons.forEach { verticalStack.addArrangedSubview($0) }
        selectCurrentDay()
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard let tappedDay = sender.title(for: .normal),
              tappedDay != selectedDay?.longDescription,
        let buttonIndex = dayButtons.firstIndex(of: sender) else { return }

        selectedDay = DayOfWeek(rawValue: buttonIndex)
        for button in dayButtons {
            button.isSelected = button.title(for: .normal) == tappedDay
        }
    }
}
