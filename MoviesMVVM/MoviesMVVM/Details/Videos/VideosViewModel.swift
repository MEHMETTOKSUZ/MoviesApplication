//
//  VideosViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import Foundation

class VideosViewModel {
    
    var videos: [DetailsHeaderView.ViewModel] = []
    var didFininshLoad: (() -> Void)?
    var didFinshLoadWithError: ((String) -> Void)?
    
    func getVideos(videoId: String) {
        guard let urlVideo = URL(string: "https://api.themoviedb.org/3/movie/\(videoId)?api_key=\(LocaleKey.API_KEY)&append_to_response=videos") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: urlVideo) { (result: Result<MovieVideoDetails?, Error>) in
               switch result {
               case .success(let videoDetails):
                   if let results = videoDetails?.videos?.results {
                       let videoViewModel = DetailsHeaderView.ViewModel(key: results.first?.key ?? "")
                       self.videos = [videoViewModel]
                       self.didFininshLoad?()
                   } else {
                       self.didFinshLoadWithError?("Failed to load videos.")
                   }
               case .failure(let error):
                   print("Error: \(error.localizedDescription)")
                   self.didFinshLoadWithError?("Failed to load videos.")
               }
           }
    }
}
