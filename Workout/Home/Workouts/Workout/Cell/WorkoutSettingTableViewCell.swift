//
//  WorkoutSettingTableViewCell.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//

import UIKit

final class WorkoutSettingTableViewCell: UITableViewCell {
    private lazy var shadowedRoundedView: ShadowedRoundedView = {
        let shadowedRoundedView = ShadowedRoundedView(arrangedSubviews: [stripeAccesory,
                                                                         settingImageView,
                                                                         headerLabel,
                                                                         subheaderLabel,
                                                                         chevronImageView])
        contentView.addSubview(shadowedRoundedView)
        shadowedRoundedView.setForegroundcolor(.systemGray6)
        return shadowedRoundedView
    }()
    
    private lazy var stripeAccesory: UIView = {
        let view = UIView()
        view.backgroundColor = .mainTheme
        return view
    }()
    
    private lazy var settingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var headerLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private lazy var subheaderLabel: MultilineLabel = {
        let label = MultilineLabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightChevron
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        shadowedRoundedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        stripeAccesory.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(6)
        }
        
        settingImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(headerLabel)
            make.height.width.equalTo(35)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(settingImageView.snp.right).offset(10)
            make.top.equalToSuperview().inset(10)
            make.right.lessThanOrEqualTo(chevronImageView.snp.left).offset(-10)
        }
        
        subheaderLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.equalTo(settingImageView)
            make.right.lessThanOrEqualTo(chevronImageView.snp.left).offset(-10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
    }
    
    func configure(with workoutSetting: WorkoutSetting) {
        settingImageView.image = workoutSetting.image
        headerLabel.text = workoutSetting.name
        subheaderLabel.text = workoutSetting.description()
    }
}
