//
//  CastCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 9.01.2024.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        let id: Int
        let image: String?
        let name: String
        let character: String
        let data: Cast
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func itemFromCell(item: ViewModel) {
        if let image = item.image {
         self.posterImage.downloaded(from: image, contentMode: .scaleToFill)
        }
         self.nameLabel.text = item.name
        self.characterLabel.text = item.character
    }
}

extension CastCollectionViewCell.ViewModel {
    init(response: Cast) {
        
        let string = "https://image.tmdb.org/t/p/w500" + (response.profile_path ?? "")
        
        self.init(id: response.id,
                  image: string,
                  name: response.name,
                  character: response.character,
                  data: response)
    }
}
