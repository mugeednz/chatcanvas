//
//  PurchaseConstants.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import Foundation

public struct ApplicationData {
    public static var id = "1515558754"             // Application id @ apple connect
    public static var name = "Skeleton"                                // Application name @ apple connect
    public static var shareString = "Share this bud 👍🏻: [https://apps.apple.com/us/app/id\(ApplicationData.id)?ls=1]"
}

public struct SubscriptionName {
    public static var EntitlementId = "Premium"                 // Revenucat subscription entitlement
    public static var OfferingId = "Premium Yearly"                     // Revenuecat offering id
    public static var ProductId = "yearlywamr"      // Revenuecat product id

}

struct FirebaseFireStoreNames {
    static let localNotificationDataCollection = "LocalNotificationData"      // Firebase Firestore collection name
    static let localNotificationDataDocument = "LongTimeInactivity"           // Firebase Firestore collection's document name
}

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public enum RoutineNotification {
   
    case ProductPurchased
    
    public var key : NSNotification.Name {
        return NSNotification.Name(rawValue:"\(self)")
    }
}

public enum RoutineError: LocalizedError {
    case runtime(String)
    case purchase(String)
}
