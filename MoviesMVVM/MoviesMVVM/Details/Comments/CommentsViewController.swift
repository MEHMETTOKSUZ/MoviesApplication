//
//  CommentsViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 10.01.2024.
//

import UIKit

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var choosenMovieId = ""
    let viewModel = CommentViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "CommnetsCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "CommnetsCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if !choosenMovieId.isEmpty {
            viewModel.getCommentsData(selected: choosenMovieId)
        } else {
            print("choosenMovieId boş")
        }
        viewModel.didFinishLoad = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension CommentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemInSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommnetsCollectionViewCell", for: indexPath) as! CommnetsCollectionViewCell
        let data = viewModel.item(at: indexPath.row)
        cell.itemFromCell(item: data)
        
        return cell
    }
}
