//
//  PurchasedViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 17.02.2024.
//

import UIKit

class PurchasedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = PurchasedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.loadPurhasedItem()
        
    }
}


extension PurchasedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = viewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "toDetailsFromPurchased", sender: selectedData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromPurchased" {
            if let indexpath = collectionView.indexPathsForSelectedItems?.first {
                if let data = viewModel.item(at: indexpath.row) {
                    let viewModel = DetailsViewModel(selectedAgent: data)
                    let destination = segue.destination as! DetailsViewController
                    destination.viewModel = viewModel
                    destination.selectedMovieId = String(viewModel.UIModel.id)
                    
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
}
