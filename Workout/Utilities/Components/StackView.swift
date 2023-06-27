//
//  StackView.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit

class StackView: UIStackView {
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
        spacing = 10
        alignment = .fill
        distribution = .fillEqually
    }
}

final class VerticalStack: StackView {
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
    }
}

final class HorizontalStack: StackView {
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
        axis = .horizontal
    }
}
