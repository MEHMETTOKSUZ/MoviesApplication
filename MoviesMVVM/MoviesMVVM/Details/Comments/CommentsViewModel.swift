//
//  CommentsViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 11.01.2024.
//

import Foundation

class CommentViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var comments: [CommnetsCollectionViewCell.ViewModel] = []
    
    var numberOfItemInSections: Int {
        return comments.count
    }
    
    func item(at index: Int) -> CommnetsCollectionViewCell.ViewModel {
        return comments[index]
    }
    
    func getCommentsData(selected: String) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(selected)/reviews?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        WebService.shared.fetchData(from: url) { (result: Result<ReviewsResponse, Error>) in
            switch result {
            case .success(let success):
                self.presentResult(item: success.results)
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
    
    func presentResult(item: [Review]) {
        
        let viewModel: [CommnetsCollectionViewCell.ViewModel] = item.map { results in
            CommnetsCollectionViewCell.ViewModel(response: results)
        }
        
        self.comments = viewModel
        self.didFinishLoad?()
    }
}
