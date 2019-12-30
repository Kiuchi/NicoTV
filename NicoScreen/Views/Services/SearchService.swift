//
//  SearchService.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine

class SearchService {
    
    static func request(_ keyword: String, _ target: Target, _ sort: Sort, _ page: Int) -> AnyPublisher<Search, RequestError> {
        
        var request = URLRequest(url: url(keyword, target, sort, page))
        request.httpMethod = "GET"
        request.setValue("ja-jp", forHTTPHeaderField: "Accept-Language")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .map { $0.toSearch(keyword, target, sort) }
            .mapError { error -> RequestError in
                switch error {
                case let urlError as URLError:
                    return .sessionFailed(error: urlError)
                case is Swift.DecodingError:
                    return .decodingFailed
                default:
                    return .other(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    

    private static func url(_ keyword: String, _ target: Target, _ sort: Sort, _ page: Int) -> URL {
        
        let targetKey: String
        switch target {
        case .tag:  targetKey = "tag/"
        default:    targetKey = "search/"
        }
        
        let sortKey: (String, String)
        switch sort {
        case .viewCountAscending:       sortKey = ("v", "a")
        case .viewCountDescending:      sortKey = ("v", "d")
        case .commentCountAscending:    sortKey = ("r", "a")
        case .commentCountDescending:   sortKey = ("r", "d")
        case .lastCommentAscending:     sortKey = ("n", "a")
        case .lastCommentDescending:    sortKey = ("n", "d")
        case .postDateAscending:        sortKey = ("f", "a")
        case .postDateDescending:       sortKey = ("f", "d")
        case .mylistCountAscending:     sortKey = ("m", "a")
        case .mylistCountDescending:    sortKey = ("m", "d")
        case .movieLengthAscending:     sortKey = ("l", "a")
        case .movieLengthDescending:    sortKey = ("l", "d")
        }
        
        let urlString = ("http://ext.nicovideo.jp/api/search/" + targetKey + keyword + "?lang=ja&order=" + sortKey.1 + "&page=" + String(page) + "&sort=" + sortKey.0)
        return URL(string: urlString.urlEncode)!
    }

    enum RequestError: Error {
        case sessionFailed(error: URLError)
        case decodingFailed
        case other(error: Error)
    }
    
    struct Response: Codable {
        let page:   Int
        let status: String
        let list:   [List]
        
        struct List: Codable {
            let id: String
            let title: String?
            let description: String?
            let thumbnailURL: String?
            let length: String?
            let viewCount: Int?
            let commentCount: Int?
            let mylistCount: Int?
            let postDate: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case title
                case description  = "description_short"
                case thumbnailURL = "thumbnail_url"
                case length
                case viewCount    = "view_counter"
                case commentCount = "num_res"
                case mylistCount  = "mylist_counter"
                case postDate     = "first_retrieve"
            }
            
            func toMovie() -> Search.Movie {
                Search.Movie(id: id,
                             title: title ?? "",
                             description: description ?? "",
                             thumbnailURL: URL(string: self.thumbnailURL ?? ""),
                             length: length,
                             viewCount: viewCount ?? 0,
                             mylistCount: mylistCount ?? 0,
                             commentCount: commentCount ?? 0,
                             postDate: postDate)
            }
        }
        
        func toSearch(_ keyword: String, _ target: Target, _ sort: Sort) -> Search {
            Search(keyword: keyword,
                   target: target,
                   sort: sort,
                   movies: list.map{ $0.toMovie() })
        }
    }
}
