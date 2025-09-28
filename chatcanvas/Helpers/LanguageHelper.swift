//
//  LanguageHelper.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import Foundation
import UIKit

class LanguageHelper {
    static var currentLanguage: String {
        // Cihazın tercih ettiği dili al
        if let preferredLanguage = Bundle.main.preferredLocalizations.first {
            return preferredLanguage
        }
        // Yedek olarak cihazın dil kodunu kullan
        return Locale.current.languageCode ?? "en"
    }
    
    static func setLanguage(_ language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Uygulamayı yeniden başlat
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = storyboard.instantiateInitialViewController()
            })
        }
    }
}
extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChange")
}
