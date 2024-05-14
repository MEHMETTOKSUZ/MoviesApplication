//
//  FavoriteViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 7.01.2024.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedFavoriteDataMovies), name: NSNotification.Name(rawValue: "newMoviesAdded"), object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
    }
    
    @objc func loadedFavoriteDataMovies() {
        
        viewModel.loadFavorites()
        
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "toDetailsFromFavorite", sender: selected)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromFavorite" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                if let data = viewModel.item(at: indexPath.row) {
                let viewModel = DetailsViewModel(selectedAgent: data)
                let destination = segue.destination as! DetailsViewController
                destination.viewModel = viewModel
                destination.selectedMovieId = String(viewModel.UIModel.id)
                
            }
            }
        }
    }
}
