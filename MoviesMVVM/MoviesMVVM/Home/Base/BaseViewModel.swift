//
//  BaseViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 1.02.2024.
//

import Foundation

class BaseViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var movies: [HomeTableViewCell.ViewModel] = []
    
    var numberOfItemInSection: Int {
        return movies.count
    }
    
    func item(at index: Int) -> HomeTableViewCell.ViewModel? {
        guard index >= 0, index < movies.count else {
            return nil
        }
        return movies[index]
    }
    
    func presentMovies(item: [Results]) {
        let viewModel: [HomeTableViewCell.ViewModel] = item.map { movies in
            HomeTableViewCell.ViewModel(response: movies)
        }
        
        self.movies = viewModel
        self.didFinishLoad?()
    }
}

