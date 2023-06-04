//
//  MultilineLabel.swift
//  Workout
//
//  Created by Salvador on 6/4/23.
//

import UIKit

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
