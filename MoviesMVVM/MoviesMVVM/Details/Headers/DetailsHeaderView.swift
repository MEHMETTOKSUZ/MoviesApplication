//
//  DetailsHeaderView.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 4.01.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetailsHeaderView: UICollectionReusableView , YTPlayerViewDelegate {
    
    struct ViewModel {
        let key: String
    }
    
    struct GenreViewModel {
        let genres: String
    }
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var realeseDateLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    var favoriteButtonClicked: (() -> ())?
    var commentButtonClicked: (() -> ())?
    var playButtonClicked: (() -> ())?
    var addCartButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.alpha = 0
        playerView.delegate = self
        activityIndicator.hidesWhenStopped = true
        posterImage.clipsToBounds = true
        posterImage.contentMode = .scaleAspectFill
        posterImage.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            playerView.alpha = 1
            activityIndicator.stopAnimating()
        }
    
    func itemFromCell(item: DetailsUIModel) {
        if let image = item.imageUrl {
            self.posterImage.downloaded(from: image, contentMode: .scaleToFill)
            self.posterImage.layer.cornerRadius = 30
        }
        
        self.overViewLabel.text = item.overview
        self.imdbLabel.text = item.imdbTitle
        self.nameLabel.text = item.nameTitle
        self.realeseDateLabel.text = item.realeseDate
        
        let imageName : String = item.isFavorite ? "star.fill": "star"
        self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        self.addCartButton.isHidden = item.isAddedCart || item.isRented
        
    }
  
    
    func createGenreLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 17)

        return label
    }
    

    func itemFromCellForGenres(item: [DetailsHeaderView.GenreViewModel]) {
        genresLabel.text = ""
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for genre in item {
            let genreLabel = createGenreLabel(withText: genre.genres)
            stackView.addArrangedSubview(genreLabel)
        }

        genresLabel.addSubview(stackView)

    }

    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        animateButton(sender: favoriteButton)
        self.favoriteButtonClicked?()
    }
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        animateButton(sender: commentButton)
        self.commentButtonClicked?()
        
    }
    
    @IBAction func playButtoNClicked(_ sender: Any) {
        animateButton(sender: playButton)
        self.playButtonClicked?()
        
    }
    
    @IBAction func addCartButtonClicked(_ sender: Any) {
        animateButton(sender: addCartButton)
        self.addCartButtonClicked?()
    }
    
    
    private func animateButton(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }
    
    func updateHeaderView(with contentOffset: CGPoint) {
        if contentOffset.y < 0 {
            let height = 441 - contentOffset.y
            let width = UIScreen.main.bounds.width + (-contentOffset.y)
            let x = -(-contentOffset.y / 2)
            posterImage.frame = CGRect(x: x, y: contentOffset.y, width: width, height: height)
        } else {
            posterImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 441)
        }
    }
}


extension DetailsHeaderView.ViewModel {
    init(response: MovieVideo) {
        
        self.init(key: response.key)
    }
}

extension DetailsHeaderView.GenreViewModel {
    init(response: Genre) {
        
        self.init(genres: response.name)
    }
}
