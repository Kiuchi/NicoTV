//
//  SearchRow.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import QGrid

struct SearchCollcection: View {
    @Binding var movies: [Search.Movie]
    
    var body: some View {
        QGrid(movies.indices, columns: 3, columnsInLandscape: 4, vSpacing: 10, hSpacing: 10, vPadding: 0, hPadding: 0) { index in
            NavigationLink(destination: MovieDetail(movie: self.$movies[index])) {
                SearchCard(movie: self.$movies[index])
            }
        }
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchCollcection(movies: .constant(Dummy.search.movies))
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
