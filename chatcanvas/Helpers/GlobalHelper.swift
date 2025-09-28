//
//  GlobalHelper.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation
import UIKit
import SafariServices
import StoreKit
import FirebaseRemoteConfig

final class GlobalHelper {
    static let shared = GlobalHelper()
    
    static func isPremiumActive() -> Bool {
        var isPremium: Bool = false
        Subscription.instance.isActive { premium in
            isPremium = premium
        }
        return isPremium
    }
    
    static func is_rate_active() -> Bool {
        var is_rate_active: Bool = false
        let value = RemoteConfig.remoteConfig()["is_rate_active"].boolValue
        if value {
            is_rate_active = true
        }
        return is_rate_active
    }
    
    static func chat_count() -> Int {
        var chat_count: Int = 0
        let value = RemoteConfig.remoteConfig()["chat_count"].stringValue
        if value != "0" {
            chat_count = Int(value) ?? 0
        }
        return chat_count
    }

    
    static func pushController<VC: UIViewController>(isAnimatedActive: Bool = true, id: String, _ vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.navigationController?.pushViewController(vc, animated: isAnimatedActive)
        }
    }

    static func presentController<VC: UIViewController>(id: String, from vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.present(vc, animated: true, completion: nil)
        }
    }
    static func openPrivacy(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/chatcanvas-privacy/ana-sayfa")
    }
    
    static func openTerms(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/chatcanvas-terms/ana-sayfa")
    }
    
    static func openContact(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/captionai/support")
    }
    static func openLinkInSafari(_ vc: UIViewController, url: String) {
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.overrideUserInterfaceStyle = .dark
        vc.present(svc, animated: true, completion: nil)
    }
    
    static func rateApp() {
        SKStoreReviewController.requestReview()
    }

    
    
}
