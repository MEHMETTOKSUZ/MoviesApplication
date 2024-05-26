//
//  Genres.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.05.2024.
//

import Foundation

class MovieGenresViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> ())?
    var genres: [DetailsHeaderView.GenreViewModel] = []
    
    func getGenres(movieId: String) {
        
        guard let genreUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(LocaleKey.API_KEY)&language=en-US&append_to_response=genres")
        else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: genreUrl) { (result: Result<MovieGenres,Error>)  in
            switch result {
            case .success(let success):
                self.presentResults(item: success.genres)
                self.didFinishLoad?()
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
    
    func presentResults(item: [Genre]) {
        
        let viewModel: [DetailsHeaderView.GenreViewModel] = item.map { results in
            DetailsHeaderView.GenreViewModel(response: results)
        }
        
        self.genres = viewModel
        self.didFinishLoad?()
    }
}


