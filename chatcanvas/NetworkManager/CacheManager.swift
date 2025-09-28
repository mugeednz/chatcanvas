//
//  CacheManager.swift
//  chatcanvas
//
//  Created by Your Name on 23.04.2025.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private let backgroundDataKey = "BackgroundDataKey"
    
    func saveBackgroundData(_ data: BackgroundModel) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: backgroundDataKey)
        }
    }
    
    func getBackgroundData() -> BackgroundModel? {
        if let data = UserDefaults.standard.data(forKey: backgroundDataKey),
           let backgroundModel = try? JSONDecoder().decode(BackgroundModel.self, from: data) {
            return backgroundModel
        }
        return nil
    }
    
    func clearBackgroundData() {
        UserDefaults.standard.removeObject(forKey: backgroundDataKey)
    }
}
