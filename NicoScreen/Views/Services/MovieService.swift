//
//  MovieService.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/11.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine

class MovieService {

    enum RequestError : Error {
        case sessionFailed(error: Error?)
        case dataFormatChanged
        case other(error: Error)
    }
    
    static func url(_ movieId: String) -> URL {
        return URL(string: "http://flapi.nicovideo.jp/api/getflv?eco=1&v=\(movieId)")!
    }
    
    static func urlPublisher(movieId: String, session: String) -> AnyPublisher<URL, RequestError> {
 
        let url = self.url(movieId)
        var request = URLRequest(url: url)
        let cookies = HTTPCookieStorage.shared.cookies(for: url)
        var headers = cookies.map{ HTTPCookie.requestHeaderFields(with: $0) } ?? [:]
        headers["Accept-Encoding"] = "gzip, deflate"
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard
                    let query = String(data: output.data, encoding: .utf8),
                    let params = convertQueryToDictionary(query),
                    let movieURL = URL(string: params["url"] ?? "")
                else {
                    throw RequestError.dataFormatChanged
                }
                return movieURL
            }
            .mapError { error -> RequestError in
                switch error {
                case let urlError as URLError:
                    return .sessionFailed(error: urlError)
                case let error as RequestError:
                    return error
                default:
                    return .other(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private static func convertQueryToDictionary(_ query: String) -> [String : String]? {
        var params = [String : String]()
        
        guard let comps = URLComponents(string: "http://hoge?\(query)") else { return nil }
        guard let queryItems = comps.queryItems else { return params }
        queryItems.forEach { params[$0.name] = $0.value }
        
        return params
    }
}
