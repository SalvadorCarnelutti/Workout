//
//  VerticalStack.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit

final class VerticalStack: UIStackView {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        axis = .vertical
        spacing = 10
        alignment = .fill
        distribution = .fillEqually
    }
}
