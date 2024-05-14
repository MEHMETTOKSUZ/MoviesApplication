//
//  PurchasedViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 17.02.2024.
//

import Foundation

class PurchasedViewModel: BaseViewModel {
    
    let paymentManager = PaymentManager.shared
    
    func loadPurhasedItem() {
        let items = paymentManager.get()
        self.presentMovies(item: items)
        self.didFinishLoad?()
    }
}
