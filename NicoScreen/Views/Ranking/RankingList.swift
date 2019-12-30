//
//  RankingList.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import Combine

struct RankingList: View {
    @ObservedObject var viewModel: RankingViewModel

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.rankings.indices, id: \.self) { index in
                        RankingRow(ranking: self.$viewModel.rankings[index])
                    }
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
        
            ActivityIndicator(isAnimating: $viewModel.isLoading)
                .shadow(radius: 5)
            
            if (viewModel.showingReloadButton) {
                Button(action: { self.viewModel.request() }) { Text("Reload") }
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.errorMessage!),
                  dismissButton: .default(Text("OK"), action: { self.viewModel.dismissAlarm() }
                  )
            )
        }
    }
}

struct RankingList_Previews: PreviewProvider {
    static var previews: some View {
        RankingList(viewModel: RankingViewModel())
    }
}

extension Ranking: Identifiable {
    var id: String { self.genre.rawValue }
}
