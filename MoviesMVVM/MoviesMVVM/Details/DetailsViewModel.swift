//
//  DetailsViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 4.01.2024.
//

import Foundation

struct DetailsUIModel {
    
    let id: Int
    let imageUrl: String?
    let nameTitle: String
    let imdbTitle: String
    let overview: String
    let realeseDate: String
    let data: HomeTableViewCell.ViewModel?
    
    var isFavorite: Bool {
        if let movieResult = data?.data {
            return FavoriteManager.shared.isFavorite(item: movieResult)
        } else {
            return false
        }
    }
    
    var isAddedCart: Bool {
        if let received = data?.data {
            return PaymentManager.shared.isPurchased(item: received)
        } else {
            return false
        }
    }
    
    var isRented: Bool {
        if let rent = data?.data {
            return RentManager.shared.isRented(item: rent)
        } else {
            return false
        }
    }
}

class DetailsViewModel {
    
    let UIModel: DetailsUIModel
    
    init(selectedAgent: HomeTableViewCell.ViewModel) {
        self.UIModel = DetailsUIModel(detailItem: selectedAgent)
    }
}


extension DetailsUIModel {
    init(detailItem: HomeTableViewCell.ViewModel) {
        
        
        self.init(id: detailItem.id,
                  imageUrl: detailItem.image,
                  nameTitle: detailItem.name,
                  imdbTitle: detailItem.imdb,
                  overview: detailItem.overview,
                  realeseDate: detailItem.releaseDate,
                  data: detailItem)
    }
}
