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

protocol SessionFormViewDelegate: AnyObject {
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
    func completionButtonTapped(for formOutput: SessionFormOutput)
}

final class SessionFormView: UIView {
    // MARK: - Properties
    weak var delegate: SessionFormViewDelegate?
    
    private lazy var headerLabel: MultilineLabel = {
        let label = MultilineLabel()
        addSubview(label)
        label.textAlignment = .center
        label.text = delegate?.headerString
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var daySelectionView: DaySelectionView = {
        let daySelectionView = DaySelectionView(style: .normal)
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
        datePicker.minuteInterval = 1
        return datePicker
    }()
    
    private lazy var completionButton: StyledButton = {
        let button = StyledButton()
        addSubview(button)
        button.setTitle(delegate?.completionString, for: .normal)
        button.addTarget(self, action: #selector(completionActionTapped), for: .touchUpInside)
        return button
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
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc private func completionActionTapped() {
        guard let selectedDay = daySelectionView.weekday,
        let startsAt = datePicker.date.formatAs("h:mm a") else { return }
        
        let formOutput = SessionFormOutput(day: selectedDay,
                                           startsAt: startsAt)
        
        delegate?.completionButtonTapped(for: formOutput)
    }
}

// MARK: - PresenterToViewProtocol
extension SessionFormView {
    func loadView() {
        backgroundColor = .systemBackground
        setupConstraints()
        delegate?.viewLoaded()
    }
    
    func setDefaultDisplay() {
        daySelectionView.selectCurrentDay()
    }
    
    func fillSessionFields(with sessionFormInput: SessionFormInput) {
        if let selectedDayOfWeek = DayOfWeek(rawValue: sessionFormInput.day) {
            datePicker.date = sessionFormInput.startsAt
            daySelectionView.selectDayOfWeek(selectedDayOfWeek)
        }
    }
}
