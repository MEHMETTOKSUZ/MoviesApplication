//
//  CartTableViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 23.01.2024.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var movieImdbLabel: UILabel!
    @IBOutlet weak var cartMovieNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func itemFromCell(item: HomeTableViewCell.ViewModel) {
        
        if let image = item.image {
            self.moviesImageView.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.cartMovieNameLabel.text = item.name
        self.movieImdbLabel.text = item.imdb
    }
    
}
