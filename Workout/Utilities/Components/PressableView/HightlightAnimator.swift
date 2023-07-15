//
//  HightlightAnimator.swift
//  Workout
//
//  Created by Salvador on 7/13/23.
//

import UIKit

open class HightlightAnimator: PressableAnimator {
    public var selectedColor: UIColor? = .lightGray
    public var unselectedColor: UIColor? = .clear

    public init() {}
    
    public func animate(view: PressableView, highlighted: Bool) {
        if highlighted {
            view.backgroundColor = selectedColor
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                view.backgroundColor = self.unselectedColor
            })
        }
    }
}
