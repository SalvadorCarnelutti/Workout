//
//  
//  AddWorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit
import CoreData

protocol AddWorkoutViewToPresenterProtocol: UIViewController {
    var managedObjectContext: NSManagedObjectContext { get }
    func viewLoaded()
}

final class AddWorkoutPresenter: BaseViewController {
    var viewAddWorkout: AddWorkoutPresenterToViewProtocol!
    var interactor: AddWorkoutPresenterToInteractorProtocol!
    var router: AddWorkoutPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewAddWorkout
        viewAddWorkout.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workout"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addExerciseTapped))
    }
    
    @objc private func addExerciseTapped() {
        router.presentExerciseForm()
    }
}

// MARK: - ViewToPresenterProtocol
extension AddWorkoutPresenter: AddWorkoutViewToPresenterProtocol {
    var managedObjectContext: NSManagedObjectContext {
        interactor.managedObjectContext
    }
    
    func viewLoaded() {}
}

final class ExerciseTableViewCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [nameLabel, durationLabel, repsLabel, setsLabel])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var setsLabel: UILabel = {
        let label = MultilineLabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstrains() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(with exercise: Exercise) {
        nameLabel.text = exercise.name
        durationLabel.text = "• Duration: \(exercise.durationString) min"
        repsLabel.text = "• Reps: \(exercise.repsString)"
        setsLabel.text = "• Sets: \(exercise.setsString)"
    }
}

extension Exercise {
    var durationString: String {
        String(format: "%.0f", duration)
    }
    
    var repsString: String {
        String(reps)
    }
    
    var setsString: String {
        String(sets)
    }
}

final class MultilineLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}
