//
//  MovieDetail.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/09.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import AVFoundation
import Combine

struct MovieDetail: View {
    private var rankingMovie: Binding<Ranking.Movie>?
    private var searchMovie: Binding<Search.Movie>?
    let movieId: String?
    
    init(movie: Binding<Ranking.Movie>) {
        rankingMovie = movie
        movieId = movie.wrappedValue.id
    }
    
    init(movie: Binding<Search.Movie>) {
        searchMovie = movie
        movieId = movie.wrappedValue.id
    }

    var body: some View {
        MovieDetailInternal(viewModel: MovieDetailModel(movieId: movieId))
    }
}

struct MovieDetailInternal: View {
    @ObservedObject var viewModel: MovieDetailModel

    var body: some View {
        ZStack {
            PlayerView(playerItem: self.$viewModel.playerItem)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            self.viewModel.requestMovieUrl()
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movie: .constant(Dummy.ranking.movies[0]))
    }
}
