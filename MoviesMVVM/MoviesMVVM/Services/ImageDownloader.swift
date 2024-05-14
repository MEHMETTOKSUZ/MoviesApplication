//
//  ImageDownloader.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 25.12.2023.
//

import Foundation
import UIKit
import Kingfisher

 extension UIImageView {
    func downloaded(from url: String?, contentMode mode: ContentMode = .scaleAspectFit, completion: ((Bool) -> Void)? = nil) {
        contentMode = mode
        guard let realPath = url else {
            return
        }
        
        let fileURL = URL(string: realPath)
        
        guard let downloadURL = fileURL else {
            return
        }
        
        let resource = KF.ImageResource(downloadURL: downloadURL, cacheKey: realPath)
        
        self.kf.indicatorType = .activity
        (kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        var options: KingfisherOptionsInfo = []
        
        options = [.transition(ImageTransition.fade(0.3)), .forceTransition]
        
        
        self.kf.setImage(with: resource,
                         options: options,
                         completionHandler:  { (result) in
                            
                            switch result {
                            case .success:
                                completion?(true)
                            case .failure:
                                completion?(false)
                            }
                         })

    }
}
