//
//  SearchView.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()

    var body: some View {
        VStack() {
            HStack {
                TextField("Keyword", text: $viewModel.keyword, onEditingChanged: { isChanged in
                    
                }) {
                    
                }
                Picker(selection: $viewModel.target, label: Text("Target")) {
                    Text("Title").tag(Target.title)
                    Text("Tag").tag(Target.tag)
                }
            }
            .padding(.horizontal, 50)
            
            HStack {
                Spacer()
                Picker(selection: $viewModel.sort, label: Text("Sort")) {
                    Text("再生順").tag(Sort.viewCountDescending)
                    Text("新着コメント順").tag(Sort.lastCommentDescending)
                    Text("投稿順").tag(Sort.postDateDescending)
                }
            }
            .padding(.horizontal, 50)

            SearchCollcection(movies: $viewModel.movies)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
