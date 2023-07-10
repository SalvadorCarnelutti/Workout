//
//  UIImage.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//

import UIKit

extension UIImage {
    private static func unwrappedImage(_ name: String) -> UIImage {
        return UIImage(systemName: name) ?? UIImage()
    }
    
    private static func unwrappedImage(_ name: String, withConfiguration configuration: UIImage.Configuration) -> UIImage {
        return UIImage(systemName: name, withConfiguration: configuration) ?? UIImage()
    }
    
    static var list: UIImage { Self.unwrappedImage("list.bullet") }
    static var calendar: UIImage { Self.unwrappedImage("calendar") }
    static var add: UIImage { Self.unwrappedImage("plus") }
    static var edit: UIImage { Self.unwrappedImage("pencil.circle.fill") }
    static var exercise: UIImage { Self.unwrappedImage("figure.walk.circle.fill") }
    static var time: UIImage { Self.unwrappedImage("clock.circle.fill") }
    static var rightChevron: UIImage {
        Self.unwrappedImage("chevron.right", withConfiguration: (UIImage.SymbolConfiguration(weight: .bold)))
            .withTintColor(.black.withAlphaComponent(0.8), renderingMode: .alwaysOriginal)
    }
    static var ellipsis: UIImage { Self.unwrappedImage("ellipsis.bubble.fill") }
    static var settings: UIImage { Self.unwrappedImage("gear") }
    static var notifications: UIImage { Self.unwrappedImage("bell.square.fill").withTintColor(.systemRed, renderingMode: .alwaysOriginal) }
    static var notificationsOff: UIImage { Self.unwrappedImage("bell.fill").withTintColor(.white, renderingMode: .alwaysOriginal) }
    static var notificationsOn: UIImage { Self.unwrappedImage("bell.badge.fill").withTintColor(.white, renderingMode: .alwaysOriginal) }
    static var darkModeOff: UIImage { Self.unwrappedImage("sun.max.fill").withTintColor(.systemYellow, renderingMode: .alwaysOriginal) }
    static var darkModeOn: UIImage { Self.unwrappedImage("moon.fill").withTintColor(.white, renderingMode: .alwaysOriginal) }
}
