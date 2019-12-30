//
//  MovieViewModel.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/14.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine
import AVKit

class MovieDetailModel: ObservableObject {
    @Published var playerItem: AVPlayerItem?
    
    private var movieId: String?
    private var cancellables: Set<AnyCancellable> = []
    
    init(movieId: String?) {
        self.movieId = movieId
    }
    
    public func requestMovieUrl() {
        
        guard let movieId = self.movieId else {
            return
        }
        
        let defaults = UserDefaults.standard
        let mail: String = defaults.string(forKey: "mailaddress-test")!
        let pass: String = defaults.string(forKey: "pass-test")!

        LoginService.request(mail, pass, movieId)
            .tryMap { $0 }
            .flatMap { session in
                MovieService.urlPublisher(movieId: movieId, session: session).tryMap { $0 }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in }) { movieUrl in

                let cookies = HTTPCookieStorage.shared.cookies(for: movieUrl) ?? [] //Stored Cookies of your request
                let header = HTTPCookie.requestHeaderFields(with: cookies)
                let options = ["AVURLAssetHTTPHeaderFieldsKey": header]

                // Create an AVPlayer, passing it the HTTP Live Streaming URL.
                let asset = AVURLAsset(url: movieUrl, options: options)
                self.playerItem = AVPlayerItem(asset: asset)
                //self.playerItem = AVPlayerItem(url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)
            }
            .store(in: &cancellables)
    }
}
