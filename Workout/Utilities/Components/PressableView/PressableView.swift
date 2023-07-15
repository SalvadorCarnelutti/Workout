//
//  PressableView.swift
//  Workout
//
//  Created by Salvador on 7/13/23.
//

import UIKit

public protocol PressableAnimator {
    func animate(view: PressableView, highlighted: Bool)
}

/*
 Implement the `PressableDelegate` to recieve press events over the view.
 */
public protocol PressableDelegate: NSObject {
    func didTap(view: PressableView)
}

/*
 `PressableView` will forward tap events to it's `pressableDelegate` whenever it is set. `PressableView`
 offers a way to customize its animation whenever the pressing occurs. To do so, create a custom `PressableAnimator`
 implementation and assing it to the view's `pressableAnimator` property.
 */
open class PressableView: UIView {
    public var pressableAnimator: PressableAnimator?
    public weak var pressableDelegate: PressableDelegate?
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pressableAnimator?.animate(view: self, highlighted: true)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pressableAnimator?.animate(view: self, highlighted: false)
        pressableDelegate?.didTap(view: self)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        pressableAnimator?.animate(view: self, highlighted: false)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
}
