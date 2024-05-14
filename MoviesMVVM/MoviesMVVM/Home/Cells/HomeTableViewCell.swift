//
//  HomeTableViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 1.01.2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    struct ViewModel {
        let id: Int
        let overview: String
        let name: String
        let image: String?
        let imdb: String
        let releaseDate: String
        let data: Results
        
        var isFavorite: Bool {
            FavoriteManager.shared.isFavorite(item: data)
        }
        
        var isAddedCart: Bool {
            PaymentManager.shared.isPurchased(item: data)
        }
        
        var isRented: Bool {
            RentManager.shared.isRented(item: data)
        }
    }
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var imdblabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var favoritButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteLabel.isHidden = true
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.numberOfLines = 2
        imdblabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        imdblabel.textAlignment = .left
        overviewLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        posterImage.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func itemFromCell(item: ViewModel) {
        
        if let image = item.image {
            self.posterImage.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.imdblabel.text = item.imdb
        self.overviewLabel.text = item.overview
        self.nameLabel.text = item.name
        
        favoriteLabel.isHidden = !item.isFavorite
        let imageName : String = item.isFavorite ? "star.fill": "star"
        self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        animateFavoriteLabelVisibility(isVisible: item.isFavorite)

    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        animateFavoriteButton()
        favoritButtonClicked?()
        
    }
    
    private func animateFavoriteButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.favoriteButton.transform = .identity
            }
        }
    }
    
    private func animateFavoriteLabelVisibility(isVisible: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.favoriteLabel.alpha = isVisible ? 1.0 : 0.0
        }
    }
}

extension HomeTableViewCell.ViewModel {
    init(response: Results) {
        let string = "https://image.tmdb.org/t/p/w500" + (response.poster_path)
        let imdbRating = String(format: "%.1f / 10 IMDb", response.vote_average)
        
        self.init(id: response.id,
                  overview: response.overview,
                  name: response.original_title,
                  image: string,
                  imdb: imdbRating,
                  releaseDate: response.release_date,
                  data: response)
    }
}
