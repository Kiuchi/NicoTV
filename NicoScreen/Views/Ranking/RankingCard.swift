//
//  RankingItem.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RankingCard: View {
    @Binding var movie: Ranking.Movie

    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: self.movie.thumbnailURL)
                .resizable()
                .scaledToFill()
                .frame(height: 340 * 9 / 16.0)
                .background(Color.gray)
                .cornerRadius(10)
                .clipped()
    
            Text(movie.title)
                .font(.body)
            
            Spacer()
        }
        .frame(width: 340, height: 350)
    }
}

struct RankingItem_Previews: PreviewProvider {
    static var previews: some View {
        RankingCard(movie: .constant(Dummy.ranking.movies[1]))
            .previewLayout(.fixed(width: 500, height: 500))
            .background(Color.gray)
    }
}
