//
//  RankingRow.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI

struct RankingRow: View {
    @Binding var ranking: Ranking
    @State private var modalDisplayed: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ranking.genre.name)
                .font(.title)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(ranking.movies.indices, id: \.self) { index in
                        NavigationLink(destination: MovieDetail(movie: self.$ranking.movies[index])) {
                            RankingCard(movie: self.$ranking.movies[index])
                        }
                        .background(Color(UIColor.clear))
                    }
                }
                .padding(.vertical, 60)
            }
        }
    }
}

struct RankingRow_Previews: PreviewProvider {
    static var previews: some View {
        RankingRow(ranking: .constant(Dummy.ranking))
    }
}


