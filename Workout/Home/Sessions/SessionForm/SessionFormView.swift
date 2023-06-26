//
//  
//  SessionFormView.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//
import UIKit
import SnapKit

protocol SessionFormPresenterToViewProtocol: UIView {
    var presenter: SessionFormViewToPresenterProtocol? { get set }
    func loadView()
}

final class SessionFormView: UIView {
    // MARK: - Properties
    weak var presenter: SessionFormViewToPresenterProtocol?
    
    private lazy var headerLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .center
        label.text = presenter?.headerString
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var daySelectionView: DaySelectionView = {
        let daySelectionView = DaySelectionView()
        addSubview(daySelectionView)
        return daySelectionView
    }()
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton()
        addSubview(button)
        button.setTitle(presenter?.completionString, for: .normal)
        button.addTarget(self, action: #selector(completionActionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        addSubview(datePicker)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.timeZone = TimeZone.current
        datePicker.minuteInterval = 5
        return datePicker
    }()
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        daySelectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(daySelectionView.snp.bottom).offset(5)
            make.right.equalTo(daySelectionView.snp.right)
            make.height.equalTo(50)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc private func completionActionTapped() {
        guard let selectedDay = daySelectionView.selectedDay?.rawValue,
        let startsAt = datePicker.date.formatAs("h:mm a") else { return }
        
        let formOutput = SessionFormOutput(day: selectedDay,
                                           startsAt: startsAt)
        
        presenter?.completionButtonTapped(for: formOutput)
    }
    
    // TODO: View knows something from the interactor, should handle logic better with a presenter method (Do same for Exercise form)
    private func fillFormFields() {
        if let formInput = presenter?.formInput,
           let selectedDayOfWeek = DayOfWeek(rawValue: formInput.day) {
            datePicker.date = formInput.startsAt
            daySelectionView.selectDayOfWeek(selectedDayOfWeek)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension SessionFormView: SessionFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        fillFormFields()
        setupConstraints()
    }
}
