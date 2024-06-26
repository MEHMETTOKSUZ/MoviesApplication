//
//  HeadersView.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 27.12.2023.
//


import Foundation
import UIKit

class CollectionHeadersView: UIView  {
    
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    var collectionViewHeight: CGFloat = 350
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 150, height: 350)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UpcomingMoviesHeaderCell.self, forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
        
        // PageControl'u oluştur ve özelleştir
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            // PageControl'ün constraint'lerini belirle
            pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



