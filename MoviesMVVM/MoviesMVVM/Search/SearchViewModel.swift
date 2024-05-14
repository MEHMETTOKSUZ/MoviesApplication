//
//  SearchViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 29.01.2024.
//

import Foundation

class SearchViewModel: BaseViewModel {
    
    func searchResponse(query: String) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(LocaleKey.API_KEY)&query=\(query)") else {
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






