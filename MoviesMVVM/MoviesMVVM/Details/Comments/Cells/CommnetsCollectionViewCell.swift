//
//  CommnetsCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 11.01.2024.
//

import UIKit

class CommnetsCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        
        let content: String
        let author: String
        let update: String
    }
    
    @IBOutlet weak var reviewName: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func itemFromCell(item: ViewModel) {
           reviewComment.text = item.content
           reviewName.text = item.author
           let isoDate = item.update
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           if let date = dateFormatter.date(from: isoDate) {
               dateFormatter.dateFormat = "dd/MM/yy HH:mm"
               let dateString = dateFormatter.string(from: date)
               reviewDateLabel.text = dateString
           }
       }
}

extension CommnetsCollectionViewCell.ViewModel {
    init(response: Review) {
        
        self.init(content: response.content,
                  author: response.author,
                  update: response.updated_at)
    }
}
