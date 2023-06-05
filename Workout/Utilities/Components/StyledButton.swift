//
//  StyledButton.swift
//  Workout
//
//  Created by Salvador on 6/5/23.
//

import UIKit

class StyledButton: UIButton {
    override public var isEnabled: Bool {
        didSet {
            let alpha: CGFloat = isEnabled ? 1.0 : 0.5
            backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        let width = titleSize.width + safeAreaInsets.left + safeAreaInsets.right
        let height = bounds.height
        return CGSize(width: width + 50, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
