//
//  Search.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

struct Search: Codable {
    var keyword: String
    var target: Target
    var sort: Sort
    var movies: [Movie]
    
    struct Movie: Codable {
        var id: String
        var title: String
        var description: String
        var thumbnailURL: URL?
        var length: String?
        var viewCount: Int
        var mylistCount: Int
        var commentCount: Int
        var postDate: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case target
        case sort
        case movies = "movie"
    }
}
