//
//  UIFont+Ext.swift
//  chatcanvas
//
//  Created by Müge Deniz on 24.04.2025.
//


import Foundation
import UIKit

extension UIFont {
    static func cousineBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Cousine-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func cousineBoldItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Cousine-BoldItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func cousineItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Cousine-Italic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func cousineRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Cousine-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
