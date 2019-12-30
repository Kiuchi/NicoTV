//
//  RankingListModel.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine

class RankingViewModel: ObservableObject {
    @Published var rankings: [Ranking] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? { willSet{ showingAlert = (newValue != nil) } }
    var showingAlert: Bool = false
    var showingReloadButton: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        request()
    }
    
    func request() {
        let term: Term = .hourly
        let genres: [Genre] = [.all, .anime, .game]
        
        isLoading = true
        
        cancellable = RankingService.requestPublisheres( genres.map {($0, term)} )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                
                self.isLoading = false
                
                switch completion {
                case .finished:
                    self.showingReloadButton = false
                case .failure(let error):
                    self.errorMessage = self.message(by: error)
                    self.showingReloadButton = true
                }
                
            }) { ranking in
                self.rankings.append(ranking)
            }
    }
    
    func message(by error: RankingService.RequestError) -> String {
        switch error {
        case .sessionFailed(_):
            return "Failed to connect with server."
        case .decodingFailed:
            return "Failed to read downloaded data."
        default:
            return "Unexpected error happened"
        }
    }
    
    func dismissAlarm() {
        errorMessage = nil
    }
}
