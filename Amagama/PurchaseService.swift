//
//  PurchaseService.swift
//  Amagama
//
//  Created by Yoli on 03/09/2022.
//

import Foundation
import RevenueCat

class PurchaseService {
    
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
    
    static func restore(productId: String?, successfullRestore: @escaping () -> Void) {
        
        Purchases.shared.restorePurchases { customerInfo, error in
            
            if let e = error {
                   // showErrorAlert(message: e.localizedDescription)
                    return
            }
            
            if customerInfo?.entitlements["basic"]?.isActive != true {
                 //   showErrorAlert(title: "Nothing found to restore 🧐", message: "We couldn't find any active subscriptions to restore. Make sure you're signed in with the correct Apple account and try again.")
                    return
                } else {
                //    showSuccess(title: "Subscription restored 👍", message: nil)
                    print("we're restoring")
                    successfullRestore()
                }
        }
    }
}
