//
//  UIColor+Ext.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    static let whatsaapGreen = "25D366".hexCode //main whatsaap green
    
    static let darkGreen = "128C7E".hexCode
    
    //succesfullColor
    static let bgGreen = "F0FDF4".hexCode
    static let textGreen = "166534".hexCode

    static let bgRed = "FEF2F2".hexCode
    static let textRed = "991B1B".hexCode
    static let whatsaapColorPalet = "EEEEEE".hexCode
    static let whatsaapSellectionGreen = "dcf8c6".hexCode
    static let bgCleanColor = "#ece5dd".hexCode
    
    static let whatsaapOfWhite = "FAF9F6".hexCode
    static let whatsaapBgBoneWhite = "F9F6EE".hexCode
    // grayTones
    static let textgray800 = "1F2937".hexCode
    static let textgray700 = "374151".hexCode
    static let textgray600 = "4B5563".hexCode
    static let textgray500 = "6B7280".hexCode
    static let textgray400 = "9CA3AF".hexCode
    static let bggray200 = "E5E7EB".hexCode
    static let bggray400 = "9CA3AF".hexCode
    static let bggray100 = "F3F4F6".hexCode
    static let bordergray300 = "D1D5DB".hexCode
    static let bordergray200 = "E5E7EB".hexCode
}
