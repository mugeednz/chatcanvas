//
//  String+Ext.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation
import UIKit
import Localize_Swift

extension String {
    
    func translate() -> String {
        return self.localized(using: "Localizable")
    }
    func translate(with arguments: CVarArg...) -> String {
            let localizedString = self.localized(using: "Localizable")
            return String(format: localizedString, arguments: arguments)
        }
    func cleanNumber() -> String {
        return self.filter { $0.isNumber }
    }
    
    var hexCode: UIColor {
        
        let hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
        func maskedName() -> String {
        let components = self.split(separator: " ")
        guard let firstName = components.first else { return self }
        
        let maskedSurname = components.dropFirst().map { _ in "****" }.joined(separator: " ")
        
        return "\(firstName.prefix(1)). \(maskedSurname)"
    }
    
    func encryptMessage() -> String {
        let encryptionMap: [Character: String] = [
            "A": "@", "B": "&", "C": "(", "D": "|)", "E": "~", "F": "#",
            "G": ">", "H": "^", "I": "!", "J": "]", "K": "<", "L": "|",
            "M": "^^", "N": "¬", "O": "*", "P": "¶", "Q": "?", "R": "®",
            "S": "$", "T": "+", "U": "µ", "V": "√", "W": "VV", "X": "%",
            "Y": "¥", "Z": "§",
            "a": "@", "b": "&", "c": "(", "d": "|)", "e": "~", "f": "#",
            "g": ">", "h": "^", "i": "!", "j": "]", "k": "<", "l": "|",
            "m": "^^", "n": "¬", "o": "*", "p": "¶", "q": "?", "r": "®",
            "s": "$", "t": "+", "u": "µ", "v": "√", "w": "VV", "x": "%",
            "y": "¥", "z": "§"
        ]
        
        return self.map { encryptionMap[$0] ?? String($0) }.joined()
    }

    func decryptMessage() -> String {
        let decryptionMap: [String: Character] = [
            "@": "A", "&": "B", "(": "C", "|)": "D", "~": "E", "#": "F",
            ">": "G", "^": "H", "!": "I", "]": "J", "<": "K", "|": "L",
            "^^": "M", "¬": "N", "*": "O", "¶": "P", "?": "Q", "®": "R",
            "$": "S", "+": "T", "µ": "U", "√": "V", "VV": "W", "%": "X",
            "¥": "Y", "§": "Z",
            "@": "a", "&": "b", "(": "c", "|)": "d", "~": "e", "#": "f",
            ">": "g", "^": "h", "!": "i", "]": "j", "<": "k", "|": "l",
            "^^": "m", "¬": "n", "*": "o", "¶": "p", "?": "q", "®": "r",
            "$": "s", "+": "t", "µ": "u", "√": "v", "VV": "w", "%": "x",
            "¥": "y", "§": "z"
        ]
        
        var decrypted = ""
        var temp = ""
        
        for char in self {
            temp.append(char)
            if let originalChar = decryptionMap[temp] {
                decrypted.append(originalChar)
                temp = ""
            }
        }
        return decrypted
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
          let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
          let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
          return boundingBox.height
      }
    
    
    @available(iOS 16.0, *)
    func firstMatch(of pattern: Regex<AnyRegexOutput>) -> Regex<AnyRegexOutput>.Match? {
        try? pattern.firstMatch(in: self)
    }
    
}
