//
//  HeaderViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 26.12.2023.
//

import Foundation

class HeaderViewModel: BaseViewModel {
 
    func getUpcomingMovies() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(LocaleKey.API_KEY)&language=en-US&page=2") else {
            print("Invali URL")
            return
            
        }
        
        WebService.shared.fetchData(from: url) { (result: Result<Movies,Error>) in
            switch result {
            case .success(let success):
                print(success)
                self.presentMovies(item: success.results)
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
}

