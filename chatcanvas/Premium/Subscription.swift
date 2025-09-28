//
//  Subscription.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import Foundation
import Purchases

public class Subscription {
    public static let instance = Subscription()
    
    var revenueCatSubscription : RevenueCatSubscription?
    
    public func isActiveErrorHandled(_ completion: @escaping (_:Result<Bool>) -> Void ) {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let purInfo = purchaserInfo, let ent = purInfo.entitlements[SubscriptionName.EntitlementId] {
                if ent.isActive {
                    completion(Result.success(true))
                } else {
                    completion(Result.success(false))
                }
            } else {
                if let error = error {
                    completion(Result.failure(error))
                }
            }
         }
    }
    
    public func isActive(_ completion: @escaping (_:Bool) -> Void ) {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let purInfo = purchaserInfo, let ent = purInfo.entitlements[SubscriptionName.EntitlementId], ent.isActive {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func setOperator(_ subcriptionOperator: SubscriptionOperator) {
        revenueCatSubscription = RevenueCatSubscription(subscriptionOperator: subcriptionOperator)
    }
    
    public func purchaseProduct(_ purchasingProduct: PurchasingProduct) {
        revenueCatSubscription?.purchaseProduct(purchasingProduct)
    }
    public func restore() {
        revenueCatSubscription?.restore()
    }
    public func fetchAvailableProducts() {
        revenueCatSubscription?.fetchAvailableProducts()
    }
    
}
