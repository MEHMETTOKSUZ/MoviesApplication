//
//  GenresViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 18.01.2024.
//

import Foundation

class GenresMoviesViewModel: BaseViewModel {
    private let genre: String
    private let baseGenresUrl = "https://api.themoviedb.org/3/discover/movie?api_key=\(LocaleKey.API_KEY)&with_genres="

    init(genre: String?) {
        guard let selectedGenre = genre else {
            fatalError("No selected genre")
        }
        self.genre = selectedGenre
    }
    
    func fetchMovies() {
        let urlString: String
        switch genre {
        case "Aksiyon":
            urlString = "\(baseGenresUrl)28"
        case "Korku":
            urlString = "\(baseGenresUrl)27"
        case "Dram":
            urlString = "\(baseGenresUrl)18"
        case "Komedi":
            urlString = "\(baseGenresUrl)35"
        case "Savaş":
            urlString = "\(baseGenresUrl)10752"
        case "Macera":
            urlString = "\(baseGenresUrl)12"
        case "Animasyon":
            urlString = "\(baseGenresUrl)16"
        case "Fantastik":
            urlString = "\(baseGenresUrl)14"
        case "Romantik":
            urlString = "\(baseGenresUrl)10749"
        case "Bilim Kurgu":
            urlString = "\(baseGenresUrl)878"
        case "Aile":
            urlString = "\(baseGenresUrl)10751"
        case "Gizem":
            urlString = "\(baseGenresUrl)9648"
        default:
            fatalError("No selected genre")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        WebService.shared.fetchData(from: url) { [weak self] (result: Result<Movies, Error>) in
            switch result {
            case .success(let movies):
                self?.presentMovies(item: movies.results)
                self?.didFinishLoad?()
            case .failure(let error):
                self?.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
}
