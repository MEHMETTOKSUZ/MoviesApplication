//
//  CastViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 9.01.2024.
//

import Foundation

class CastViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var casting: [CastCollectionViewCell.ViewModel] = []
    
    var numberOfItemInSections: Int {
        return casting.count
    }
    
    func item(at index: Int) -> CastCollectionViewCell.ViewModel {
        return casting[index]
    }
    
    func getCastData(selected: String) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(selected)/credits?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        WebService.shared.fetchData(from: url) { (result: Result<Credits, Error>) in
            switch result {
            case .success(let success):
                self.presentResult(item: success.cast)
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
    
    func presentResult(item: [Cast]) {
        
        let viewModel: [CastCollectionViewCell.ViewModel] = item.map { results in
            CastCollectionViewCell.ViewModel(response: results)
        }
        
        self.casting = viewModel
        self.didFinishLoad?()
    }
}
