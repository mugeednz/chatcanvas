//
//  UIView+Ext.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat? = nil) {
        layer.masksToBounds = true
        if let radius = radius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = self.frame.height / 2
        }
    }
    func addShadow(cornerRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
          self.layer.cornerRadius = cornerRadius
          self.layer.masksToBounds = false
          self.layer.shadowColor = shadowColor.cgColor
          self.layer.shadowOpacity = shadowOpacity
          self.layer.shadowOffset = shadowOffset
          self.layer.shadowRadius = shadowRadius
      }
}
