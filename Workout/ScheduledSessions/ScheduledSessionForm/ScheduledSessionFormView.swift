//
//  
//  ScheduledSessionFormView.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import UIKit
import CoreData

protocol ScheduledSessionFormPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: ScheduledSessionFormViewToPresenterProtocol? { get set }
    func loadView()
}

final class ScheduledSessionFormView: UIView {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormViewToPresenterProtocol?
    
    private lazy var daySelectionView: DaySelectionView = {
        let daySelectionView = DaySelectionView(style: .compact)
        addSubview(daySelectionView)
        return daySelectionView
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
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton()
        addSubview(button)
        button.setTitle(presenter?.completionString, for: .normal)
        button.addTarget(self, action: #selector(completionActionTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupConstraints() {
        daySelectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
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
        
//        presenter?.completionButtonTapped(for: formOutput)
    }
    
    // TODO: View knows something from the interactor, should handle logic better with a presenter method (Do same for Exercise form)
    private func fillFormFields() {
//        if let formInput = presenter?.formInput,
//           let selectedDayOfWeek = DayOfWeek(rawValue: formInput.day) {
//            datePicker.date = formInput.startsAt
//            daySelectionView.selectDayOfWeek(selectedDayOfWeek)
//        }
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionFormView: ScheduledSessionFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}
