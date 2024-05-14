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
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var realeseDateLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    var favoriteButtonClicked: (() -> ())?
    var commentButtonClicked: (() -> ())?
    var playButtonClicked: (() -> ())?
    var addCartButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.alpha = 0
        playerView.delegate = self
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.alpha = 1
        
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
}


extension DetailsHeaderView.ViewModel {
    init(response: MovieVideo) {
        
        self.init(key: response.key)
    }
}
