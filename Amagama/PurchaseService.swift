//
//  PurchaseService.swift
//  Amagama
//
//  Created by Yoli on 03/09/2022.
//

import Foundation
import RevenueCat

class PurchaseService {
    
    //@EnvironmentObject var store: ThemeStore
    
    static func purchase(productId: String?, successfulPurchase: @escaping () -> Void) {
        
        guard productId != nil else {
            return
        }
        
        //implement purchases using revenuecat
        //get the SKProduct
        Purchases.shared.getProducts([productId!]) { (products) in
            
            if !products.isEmpty {
                
                let skProduct = products[0]
                
                //Purchase it
                Purchases.shared.purchase(product: skProduct) { transaction, purchaserInfo, error, userCancelled in
                    
                    if error == nil && !userCancelled {
                        //succesful purchase
                        successfulPurchase()
                    }
                }
                
            }
        }
        
    }
    
    static func restore(productId: String?, restore: @escaping (Bool) -> Void) {
        var myErrorString = ""
        guard productId != nil else {
            return 
        }
        
        Purchases.shared.restorePurchases { customerInfo, error in
            
            if let e = error {
                print(e)
                return
            }
            print(customerInfo?.allPurchasedProductIdentifiers)
            
          //  if customerInfo?.entitlements["basic"]?.isActive != true {
            
            guard let possibleSet = customerInfo?.allPurchasedProductIdentifiers else { return }
            
            if possibleSet.contains("19BuyableSentences") {
                print("we succesfully restored")
                restore(true)
            } else {
                print("we couldn't restored")
                restore(false)
            }
            
            
            
            
//            if let p = customerInfo?.allPurchasedProductIdentifiers {
//                if p.contains("19BuyableSentences") {
//                    print("we succesfully restored")
//                    restore(true)
//                    return
//                } else {
//                    print("we couldn't restored")
//                    restore(false)
//                    return
//                }
//            }
                
        
        }
    }
}
