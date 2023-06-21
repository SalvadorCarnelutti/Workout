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
    
    static var add: UIImage { Self.unwrappedImage("plus") }
    static var edit: UIImage { Self.unwrappedImage("pencil") }
    static var exercise: UIImage { Self.unwrappedImage("figure.walk") }
    static var time: UIImage { Self.unwrappedImage("clock") }
}
