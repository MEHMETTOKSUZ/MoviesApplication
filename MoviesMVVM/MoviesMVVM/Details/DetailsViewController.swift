//
//  DetailsViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 1.01.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetailsViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    var viewModel: DetailsViewModel!
    let castViewModel = CastViewModel()
    let videoViewModel = VideosViewModel()
    var selectedMovieId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PaymentManager.shared.loadPurchasedItems()
        RentManager.shared.loadRentedItems()
        registerCells()
        loadData()
        
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func registerCells() {
        
        let viewNibName = UINib(nibName: "DetailsHeaderView", bundle: nil)
        self.headerCollectionView.register(viewNibName, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailsHeaderView")
        
        let nibName = UINib(nibName: "CastCollectionViewCell", bundle: nil)
        self.headerCollectionView.register(nibName, forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
    
    func loadData() {
        
        if !selectedMovieId.isEmpty {
            castViewModel.getCastData(selected: selectedMovieId)
            videoViewModel.getVideos(videoId: selectedMovieId)
            
        } else {
            print("selectedMovieId is empty")
        }
        castViewModel.didFinishLoad = {
            DispatchQueue.main.async {
                self.headerCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel.numberOfItemInSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
        let data = castViewModel.item(at: indexPath.row)
        cell.itemFromCell(item: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailsHeaderView", for: indexPath) as! DetailsHeaderView
        
        view.itemFromCell(item: viewModel.UIModel)
        
        view.favoriteButtonClicked = {
            if let data = self.viewModel.UIModel.data {
                FavoriteManager.shared.add(item: data.data)
                view.itemFromCell(item: self.viewModel.UIModel)
                NotificationCenter.default.post(name: NSNotification.Name("MoviesAdded"), object: nil)
            } else {
                print("Favoriye Eklenemedi")
            }
        }
        
        view.commentButtonClicked = {
            let data = self.castViewModel.item(at: indexPath.row)
            self.performSegue(withIdentifier: "toReviewsVC", sender: data)
        }
        
        view.playButtonClicked = {
            guard let data = self.viewModel.UIModel.data else {
                print("Data not available.")
                return
            }

            if data.isAddedCart || data.isRented {
                if let key = self.videoViewModel.videos.first?.key {
                    DispatchQueue.main.async {
                        view.playerView.load(withVideoId: key)
                    }
                } else {
                    print("Video key is nil.")
                }
            } else {
                self.makeAlert(titleInput: "Bildirim", messageInput: "Bu videoyu izleyebilmek için önce satın almalı veya kiralamalısınız.")
            }
        }

        view.addCartButtonClicked = {
            
            if let data = self.viewModel.UIModel.data {
                CartManager.shared.add(item: data.data)
            } else {
                print("Sepete eklenemedi")
            }
        }
        
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewsVC" {
            if let destinationVC = segue.destination as? CommentsViewController {
                destinationVC.choosenMovieId = selectedMovieId
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.height)
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}
