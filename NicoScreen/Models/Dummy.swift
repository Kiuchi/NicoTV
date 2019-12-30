//
//  Dummy.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine
import XMLCoder

class Dummy {
    
    static let ranking = load("RankingSample.xml", .xml, as: RankingService.Response.self).toRanking(Genre.all, Term.daily)
    static let search  = load("SearchSample.json", .json, as: SearchService.Response.self).toSearch("tt", .title, .viewCountAscending)
    
    
    private static func load<T: Decodable>(_ filename: String, _ format: FileFormat, as type: T.Type = T.self) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            switch format {
            case .xml:  return try XMLDecoder().decode(type, from: data)
            case .json: return try JSONDecoder().decode(type, from: data)
            }
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    
    enum FileFormat {
        case xml
        case json
    }
}
