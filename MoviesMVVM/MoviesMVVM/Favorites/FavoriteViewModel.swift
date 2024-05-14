//
//  FavoriteViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 7.01.2024.
//

import Foundation

class FavoriteViewModel: BaseViewModel {
 
    let favoriteManager = FavoriteManager.shared
    
    func loadFavorites() {
        
        let items = favoriteManager.get()
        self.presentMovies(item: items)
        self.didFinishLoad?()
    }
}
