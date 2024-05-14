//
//  GenresViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 18.01.2024.
//

import UIKit

class GenresCategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var genres = ["Aksiyon", "Korku", "Dram", "Komedi", "Savaş", "Macera", "Animasyon", "Fantastik", "Romantik", "Bilim Kurgu", "Aile", "Gizem"]
    var genresImages = [
        "Aksiyon": UIImage(named: "Aksiyon")!,
        "Korku": UIImage(named: "Korku")!,
        "Dram": UIImage(named: "Dram")!,
        "Komedi": UIImage(named: "Komedi")!,
        "Savaş": UIImage(named: "Savaş")!,
        "Macera": UIImage(named: "Macera")!,
        "Animasyon": UIImage(named: "Animasyon")!,
        "Fantastik": UIImage(named: "Fantastik")!,
        "Romantik": UIImage(named: "Romantik")!,
        "Bilim Kurgu": UIImage(named: "Bilim Kurgu")!,
        "Aile": UIImage(named: "Aile")!,
        "Gizem": UIImage(named: "Gizem")!]
    
    var selectedGenre: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "GenresHomeCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "GenresHomeCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
}

extension GenresCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresHomeCollectionViewCell", for: indexPath) as! GenresCategoryCollectionViewCell
        
        let genres = genres[indexPath.row]
        let image = genresImages[genres]
        cell.itemFromCell(genre: genres, image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
      let genresMoviesVC = storyboard?.instantiateViewController(withIdentifier: "GenresMoviesFromGenres") as? MoviesViewController
        genresMoviesVC?.genre = genre
        navigationController?.pushViewController(genresMoviesVC!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenresMoviesFromGenres" {
            let destinationVC = segue.destination as! MoviesViewController
            destinationVC.genre = selectedGenre
        }
    }
}
