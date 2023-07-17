//
//  ShadowedRoundedView.swift
//  Workout
//
//  Created by Salvador on 7/5/23.
//

import UIKit
import SnapKit

final class ShadowedRoundedView: PressableView {
    private static let cornerRadius: CGFloat = 4.0
    private static let shadowCornerRadius: CGFloat = 3.0
    
    override var backgroundColor: UIColor? {
        get { roundedForeground.backgroundColor }
        set { roundedForeground.backgroundColor = newValue }
    }
    
    private lazy var roundedForeground: UIView = {
        let roundedForeground = UIView()
        addSubview(roundedForeground)
        roundedForeground.layer.cornerRadius = Self.cornerRadius
        roundedForeground.backgroundColor = .clear
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
        pressableAnimator = ShrinkPressableAnimator()
        arrangedSubviews.forEach { addSubviewToForeground($0) }
        setupConstraints()
    }
    
    func addSubviewToForeground(_ view: UIView) {
        roundedForeground.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

