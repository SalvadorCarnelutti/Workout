//
//  DaySelectionView.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import UIKit

final class DaySelectionView: UIView {
    private var selectedDay: String?
    
    private let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
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
    
    private func setupViews() {
        dayButtons.forEach { verticalStack.addArrangedSubview($0) }
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard let tappedDay = sender.title(for: .normal), tappedDay != selectedDay else { return }

        selectedDay = tappedDay
        for button in dayButtons {
            button.isSelected = button.title(for: .normal) == tappedDay
        }
        
        // Maybe set delegate to inform on last selectedDay
    }
}
