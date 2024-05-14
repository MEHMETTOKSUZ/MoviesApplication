//
//  FavoriteCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 7.01.2024.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoritePosterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func itemFromCell(item: HomeTableViewCell.ViewModel) {
        if let image = item.image {
            self.favoritePosterImage.downloaded(from: image, contentMode: .scaleToFill)
            
            self.favoritePosterImage.layer.cornerRadius = 25
        }
    }
}
