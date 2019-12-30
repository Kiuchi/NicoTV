//
//  SearchCard.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchCard: View {
    @Binding var movie: Search.Movie
    
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
                .font(.caption)
                
            Spacer()
        }
        .frame(width: 340, height: 350)
    }
}

struct SearchCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchCard(movie: .constant(Dummy.search.movies[0]))
            .previewLayout(.fixed(width: 500, height: 500))
            .background(Color.gray)
    }
}
