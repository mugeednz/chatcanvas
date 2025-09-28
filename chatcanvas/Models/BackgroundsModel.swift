//
//  BackgroundsModel.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation

struct BackgroundModel: Codable {
    let response: Response
    let translations: [String: [String: String]] // Dil bazlı çeviri tablosu
}

struct Response: Codable {
    let classic: [BackgroundCategory]
    let popular: [BackgroundCategory]
}

struct BackgroundCategory: Codable {
    let type: String
    let title: String
    let subtitle: String
    let image: String
    let images: [Art]?
    let premium: Bool
}

struct Art: Codable {
    let title: String
    let subtitle: String
    let image: String
}

// MARK: - Helper Methods
extension BackgroundModel {
    static func parse(from data: Data) -> BackgroundModel? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(BackgroundModel.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func allCategories() -> [BackgroundCategory] {
        return response.classic + response.popular
    }
    
    // Cihaz diline göre çevrilmiş kategori döndüren yardımcı metod
    func localizedCategories() -> [BackgroundCategory] {
            let userLanguage = LanguageHelper.currentLanguage
            
            return allCategories().map { category in
                let titleKey = "\(category.type)_title"
                let subtitleKey = "\(category.type)_subtitle"
                
                // Çeviri anahtarlarını kontrol et
                if translations[titleKey] == nil {
                }
                if translations[titleKey]?[userLanguage] == nil {
                }
                
                let localizedTitle = translations[titleKey]?[userLanguage] ?? translations[titleKey]?["en"] ?? category.title
                let localizedSubtitle = translations[subtitleKey]?[userLanguage] ?? translations[subtitleKey]?["en"] ?? category.subtitle
                
                
                let localizedImages = category.images?.enumerated().map { (index, art) in
                    let artTitleKey = "\(category.type)_art_\(index + 1)_title"
                    let artSubtitleKey = "\(category.type)_art_\(index + 1)_subtitle"
                    
                    let localizedArtTitle = translations[artTitleKey]?[userLanguage] ?? translations[artTitleKey]?["en"] ?? art.title
                    let localizedArtSubtitle = translations[artSubtitleKey]?[userLanguage] ?? translations[artSubtitleKey]?["en"] ?? art.subtitle
                    
                    return Art(
                        title: localizedArtTitle,
                        subtitle: localizedArtSubtitle,
                        image: art.image
                    )
                }
                
                return BackgroundCategory(
                    type: category.type,
                    title: localizedTitle,
                    subtitle: localizedSubtitle,
                    image: category.image,
                    images: localizedImages,
                    premium: category.premium
                )
            }
        }
    }
