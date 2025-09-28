//
//  RevenueCatSubscription.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import Foundation
import Purchases

typealias Package = Purchases.Package

public protocol SubscriptionOperator {
    func premiumVersionRestored()
    func purchasesDisabledOnDevice()
    func setPurchasingProducts(_ purchasingProducts:[PurchasingProduct])
    func premiumProductPurchased()
    func purchaseStarted()
    func purchaseFinished()
    func fetchingProductFailure()
}

// Autorenewal subscription using RevenueCat
public class RevenueCatSubscription {
    
    var subscriptionOperator : SubscriptionOperator
    var packages : [Package] = []
    
    init(subscriptionOperator : SubscriptionOperator) {
        self.subscriptionOperator = subscriptionOperator
    }
    
    func fetchAvailableProducts() {
        Purchases.shared.offerings { (offerings, error) in
            guard error == nil else {
                ApplicationLogger.Error("Purchase : Fetch offerings error :")
                ApplicationLogger.Error(error!)
                return
            }
            var purchasingProducts : [PurchasingProduct] = []
            
            if let offers = offerings?.all {
                for offer in offers {
                    let packages = offer.value.availablePackages
                    if packages.count > 0 {
                        self.packages = packages
                        ApplicationLogger.Log("--- Packages fetched successfully 🎉")
                    } else {
                        ApplicationLogger.Warning("Purchases : Offering - package count is zero")
                    }
                    packages.forEach { package in
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.formatterBehavior = .behavior10_4
                        numberFormatter.numberStyle = .currency
                        numberFormatter.locale =  package.product.priceLocale //priceLocale
                        let price = numberFormatter.string(from:  package.product.price) ?? "-"
                        purchasingProducts.append(PurchasingProduct(productIdentifier: package.product.productIdentifier, productPrice: price, package: package))
                    }
                    self.subscriptionOperator.setPurchasingProducts(purchasingProducts)
                }
            }
            
        }
        
    }
    
    // purchases
    func purchaseProduct(_ purchasingProduct: PurchasingProduct) {
        guard packages.count > 0 else {
            fetchAvailableProducts()
            return
        }
        subscriptionOperator.purchaseStarted()
        Purchases.shared.purchasePackage(purchasingProduct.package) { (transaction, purchaserInfo, error, userCancelled) in
            if let e = error {
                if userCancelled {
                    self.subscriptionOperator.purchaseFinished()
                }
                ApplicationLogger.Log("PURCHASE ERROR: - \(e.localizedDescription)")
                self.subscriptionOperator.purchaseFinished()
                return
            }

            if purchaserInfo?.entitlements.active.first != nil {
                ApplicationLogger.Log("Purchased product 🎉")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
                if let periodType = purchaserInfo?.entitlements.active.first?.value.periodType {
                    self.subscriptionOperator.premiumProductPurchased()
                }
            }
            NotificationCenter.default.post(name: RoutineNotification.ProductPurchased.key, object: nil)
            self.subscriptionOperator.purchaseFinished()
        }
    }
    
    func restore() {
        subscriptionOperator.purchaseStarted()
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let e = error {
                ApplicationLogger.Log("RESTORE ERROR: - \(e.localizedDescription)")
            } else if purchaserInfo?.entitlements.active.first != nil {
                ApplicationLogger.Log("Restored product 🎉")
                
                self.subscriptionOperator.premiumVersionRestored()
            }
            NotificationCenter.default.post(name: RoutineNotification.ProductPurchased.key, object: nil)
            self.subscriptionOperator.purchaseFinished()
        }
    }
    
}

public class PurchasingProduct {
    internal init(productIdentifier: String, productPrice: String, package: Package) {
        self.productIdentifier = productIdentifier
        self.productPrice = productPrice
        self.package = package
    }
    
    public private(set) var productIdentifier : String
    public private(set) var productPrice : String
    internal var package : Package
}
