//
//  ApplicationLogger.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import Foundation

public class ApplicationLogger {
    fileprivate static func printer(_ message : String) {
        print("\(message)")
    }
    
    public static func Log(_ message : String) {
        printer("✏️ \(message)")
    }
    public static func Error(_ error : Error) {
        printer("❌❌❌ \(error)")
    }
    public static func Error(_ message : String) {
        printer("❌❌❌ \(message)")
    }
    public static func Warning(_ message : String) {
        printer("⚠️ \(message)")
    }
    public static func Line() {
        printer("  ⬜⬜⬜⬜⬜  ")
    }
    
}
