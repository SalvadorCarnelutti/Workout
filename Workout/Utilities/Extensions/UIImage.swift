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
        return UIImage(systemName: name, withConfiguration: configuration)?.withTintColor(.black.withAlphaComponent(0.8), renderingMode: .alwaysOriginal) ?? UIImage()
    }
    
    static var list: UIImage { Self.unwrappedImage("list.bullet") }
    static var calendar: UIImage { Self.unwrappedImage("calendar") }
    static var add: UIImage { Self.unwrappedImage("plus") }
    static var edit: UIImage { Self.unwrappedImage("pencil.circle.fill") }
    static var exercise: UIImage { Self.unwrappedImage("figure.walk.circle.fill") }
    static var time: UIImage { Self.unwrappedImage("clock.circle.fill") }
    static var rightChevron: UIImage { Self.unwrappedImage("chevron.right", withConfiguration: (UIImage.SymbolConfiguration(weight: .bold))) }
    static var ellipsis: UIImage { Self.unwrappedImage("ellipsis.bubble.fill") }
}
