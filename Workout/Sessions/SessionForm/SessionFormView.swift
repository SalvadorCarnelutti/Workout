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
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        daySelectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension SessionFormView: SessionFormPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}
