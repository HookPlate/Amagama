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
}
