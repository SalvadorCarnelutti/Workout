//
//  ShadowedRoundedView.swift
//  Workout
//
//  Created by Salvador on 7/5/23.
//

import UIKit
import SnapKit

final class ShadowedRoundedView: UIView {
    private static let cornerRadius: CGFloat = 4.0
    private static let shadowCornerRadius: CGFloat = 3.0
    
    private lazy var roundedForeground: UIView = {
        let roundedForeground = UIView()
        addSubview(roundedForeground)
        roundedForeground.layer.cornerRadius = Self.cornerRadius
        roundedForeground.backgroundColor = .systemBackground
        roundedForeground.clipsToBounds = true
        return roundedForeground
    }()
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    init(arrangedSubviews: [UIView]) {
        super.init(frame: .zero)
        arrangedSubviews.forEach { roundedForeground.addSubview($0) }
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setForegroundcolor(_ color: UIColor) {
        roundedForeground.backgroundColor = color
    }
    
    private func setupConstraints() {
        roundedForeground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = Self.shadowCornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Self.shadowCornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

