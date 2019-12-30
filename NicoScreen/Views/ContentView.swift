//
//  ContentView.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    var cancellbale: AnyCancellable?

    var body: some View {
        return NavigationView {
            TabView() {
                RankingList(viewModel: RankingViewModel()).tabItem { Text("Ranking") }
                SearchView().tabItem { Text("Search") }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
