//
//  CartViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import Foundation

class CartViewModel: BaseViewModel {
    
    let cartManager = CartManager.shared

    func loadCartItems() {
        
        let items = cartManager.get()
        self.presentMovies(item: items)
        self.didFinishLoad?()
       
    }
    
    func deleteItem(indexPath: IndexPath) {
        defer {
            loadCartItems()
        }
        
        let movie = item(at: indexPath.row)
        cartManager.delete(for: movie?.id  ?? 0)
    }
}
