//
//  SearchViewModel.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    
    // MARK: - Input

    @Published var keyword: String = ""
    @Published var target: Target = .title
    @Published var sort: Sort = .lastCommentDescending
    
    // MARK: - Output
    
    @Published var movies: [Search.Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? { willSet{ showingAlert = (newValue != nil) } }
    var showingAlert: Bool = false
    
    private var requestedPages: Int = 0
    private var cancellables: Set<AnyCancellable> = []
    
    
    init () {
        $keyword.sink { self.request($0, self.target, self.sort) }.store(in: &cancellables)
        $target.sink { self.request(self.keyword, $0, self.sort) }.store(in: &cancellables)
        $sort.sink { self.request(self.keyword, self.target, $0) }.store(in: &cancellables)
    }
    
    
    func request(_ keyword: String, _ target: Target, _ sort: Sort) {
        self.isLoading = true
        let nextPage = requestedPages + 1
        
        SearchService.request(keyword, target, sort, nextPage)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                
                self.isLoading = false
                
                switch completion {
                case .finished:
                    self.requestedPages += 1
                case .failure(let error):
                    self.errorMessage = self.message(by: error)
                }
                
            }) { responce in
                self.movies += responce.movies
            }
            .store(in: &cancellables)
    }
    
    
    func message(by error: SearchService.RequestError) -> String {
        switch error {
        case .sessionFailed(_):
            return "Failed to connection with server."
        case .decodingFailed:
            return "Failed to read downloaded data."
        default:
            return "Unexpected error happened"
        }
    }
    
    
    func dismissError() {
        errorMessage = nil
    }
}
