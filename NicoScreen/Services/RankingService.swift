//
//  RankingService.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine
import XMLCoder
import SwiftSoup

class RankingService {
    
    static func request(_ genre: Genre, _ term: Term, _ completion: @escaping (Result<Ranking, RequestError>) -> Void) {
        var request = URLRequest(url: makeUrl(genre, term))
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(Result.failure(RequestError.sessionFailed(error: error)))
                return
            }
            guard let rankingRss = try? XMLDecoder().decode(Response.self, from: data) else {
                completion(Result.failure(RequestError.decodingFailed))
                return
            }
            completion(Result.success(rankingRss.toRanking(genre, term)))
            
        }.resume()
    }

    
    static func requestPublisher(_ genre: Genre, _ term: Term) -> AnyPublisher<Ranking, RequestError> {
        var request = URLRequest(url: makeUrl(genre, term))
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: XMLDecoder())
            .map{ $0.toRanking(genre, term) }
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
    
    
    static func requestPublisheres(_ tasks: [(genre: Genre, term: Term)]) -> AnyPublisher<Ranking, RequestError> {
        tasks.map { requestPublisher($0.genre, $0.term) }
             .reduce(AnyPublisher<Ranking, RequestError>(Empty())) { $0.merge(with: $1).eraseToAnyPublisher() }
    }

    
    static func makeUrl(_ genre: Genre, _ term: Term) -> URL {
        return URL(string: "https://www.nicovideo.jp/ranking/genre/\(genre.rawValue)?&term=\(term.rawValue)&rss=2.0&lang=ja-jp")!
    }
    

    enum RequestError : Error {
        case sessionFailed(error: Error?)
        case decodingFailed
        case other(error: Error)
    }
    

    struct Response: Codable {
        var channel: Channel
        
        struct Channel: Codable {
            var link: String
            var item: [Item]
        }

        struct Item: Codable {
            var title: String
            var link: String
            var description: String
            
            func toMovie(_ rank: Int) -> Ranking.Movie? {
                // Remove rank from title string
                let regex = try! NSRegularExpression(pattern: "^第\\d+?位：")
                let matches = regex.matches(in: title, range: NSRange(location: 0, length: title.count))
                var rawTitle = title
                if let match = matches.first, let range = Range(match.range, in: title) {
                    rawTitle.removeSubrange(range)
                }
                
                // Extract html from CDATA
                guard let doc = try? SwiftSoup.parse(description) else { return nil }

                let description  = try? doc.select("p.nico-description img").first()?.text()
                let thumbnailUrl = try? URL(string: doc.select("p.nico-thumbnail img").first()?.attr("src") ?? "")
                let length       = try? doc.select("strong.nico-info-length").first()?.text()
                let postDate     = try? doc.select("strong.nico-info-date").first()?.text()
                let viewCount    = try? Int(doc.select("strong.nico-info-total-view").first()?.text().replacingOccurrences(of: ",", with: "") ?? "")
                let mylistCount  = try? Int(doc.select("strong.nico-info-total-mylist").first()?.text().replacingOccurrences(of: ",", with: "") ?? "")
                let commentCount = try? Int(doc.select("strong.nico-info-total-res").first()?.text().replacingOccurrences(of: ",", with: "") ?? "")

                return Ranking.Movie(rank: rank,
                                     title: rawTitle,
                                     link: self.link,
                                     description: description ?? "",
                                     thumbnailURL: thumbnailUrl,
                                     length: length,
                                     postDate: postDate,
                                     viewCount: viewCount ?? 0,
                                     mylistCount: mylistCount ?? 0,
                                     commentCount: commentCount ?? 0)
            }
        }
        
        func toRanking(_ genre: Genre, _ term: Term) -> Ranking {
            return Ranking(genre: genre, term: term, movies: zip(channel.item.indices, channel.item).compactMap { $0.1.toMovie($0.0 + 1) })
        }
    }
}
