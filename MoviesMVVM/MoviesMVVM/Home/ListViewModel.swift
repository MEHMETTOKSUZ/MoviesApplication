//
//  MoviesViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 25.12.2023.
//

import Foundation

class ListViewModel: BaseViewModel {

    func getNowPlayingMovies() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(LocaleKey.API_KEY)&language=en-US&page=1") else {
            print("Invali URL")
            return
            
        }
        
        WebService.shared.fetchData(from: url) { (result: Result<Movies,Error>) in
            switch result {
            case .success(let success):
                self.presentMovies(item: success.results)
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
}



