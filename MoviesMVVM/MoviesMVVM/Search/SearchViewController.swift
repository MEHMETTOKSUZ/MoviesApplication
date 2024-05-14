//
//  SearchViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 27.01.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    let viewModel = SearchViewModel()
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibname = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nibname, forCellReuseIdentifier: "HomeTableViewCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        cell.favoritButtonClicked = {
            if let data = self.viewModel.item(at: indexPath.row) {
                FavoriteManager.shared.add(item: data.data)
                cell.itemFromCell(item: data)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = viewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "detailsFromSearch", sender: selectedData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsFromSearch" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let data = viewModel.item(at: indexPath.row) {
                    let viewModel = DetailsViewModel(selectedAgent: data)
                    let destination = segue.destination as! DetailsViewController
                    destination.viewModel = viewModel
                    destination.selectedMovieId = String(viewModel.UIModel.id)
                    
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            viewModel.searchResponse(query: query)
            tableView.reloadData()
        }
    }
    
}

