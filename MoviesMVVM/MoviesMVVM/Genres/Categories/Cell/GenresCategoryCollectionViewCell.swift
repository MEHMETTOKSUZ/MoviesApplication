//
//  GenresHomeCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 18.01.2024.
//

import UIKit

class GenresCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genresImageView: UIImageView!
    @IBOutlet weak var genresNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func itemFromCell(genre: String, image: UIImage?) {
        
        self.genresNameLabel.text = genre
        self.genresImageView.image = image
        
       }
}

