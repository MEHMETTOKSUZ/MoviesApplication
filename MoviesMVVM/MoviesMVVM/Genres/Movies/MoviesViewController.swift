//
//  MoviesViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var genre: String?
    var viewmodel: GenresMoviesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibname = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nibname, forCellReuseIdentifier: "HomeTableViewCell")

        viewmodel = GenresMoviesViewModel(genre: genre)
        viewmodel.fetchMovies()
        self.viewmodel.didFinishLoad = {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            FavoriteManager.shared.loadFavoriteMovies()
    }
}
        
        tableView.delegate = self
        tableView.dataSource = self

    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberOfItemInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        guard let data = viewmodel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        cell.favoritButtonClicked = {
            guard let data = self.viewmodel.item(at: indexPath.row) else {
                return
            }
            FavoriteManager.shared.add(item: data.data)
            cell.itemFromCell(item: data)
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = viewmodel.item(at: indexPath.row)
        performSegue(withIdentifier: "toDetailsFromGenresMovies", sender: selectedData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromGenresMovies" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let data = viewmodel.item(at: indexPath.row) {
                let viewModel = DetailsViewModel(selectedAgent: data)
                let destination = segue.destination as! DetailsViewController
                destination.viewModel = viewModel
                destination.selectedMovieId = String(viewModel.UIModel.id)
                
            }
            }
        }
    }
}

