//
//  LoginService.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/11.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation
import Combine
import Alamofire

class LoginService {
    
    enum RequestError : Error {
        case sessionFailed(error: Error?)
        case cookieNotFound
        case other(error: Error)
    }
    
    static let url = URL(string: "https://secure.nicovideo.jp/secure/login?site=niconico")!
    
    static func request(_ username: String, _ pass: String, _ movieid: String) -> AnyPublisher<String, RequestError> {
        
        let publisher = PassthroughSubject<String, RequestError>()
        let param = ["mail":username, "password":pass]

        // Prevent to redirect
        Alamofire.SessionManager.default.delegate.taskWillPerformHTTPRedirection = { (session, task, response, request) in
            return nil
        }

        Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: [:]).responseData { response in
            switch response.result {
            case .success:
                
                guard
                    let headers = response.response?.allHeaderFields as? [String : String],
                    let url = response.response?.url
                else {
                    publisher.send(completion: .failure(RequestError.cookieNotFound))
                    return
                }
                
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                let cookie = cookies.filter{ $0.name == "user_session" }.filter{ $0.value != "deleted" }.first
                guard let cookieValue = cookie?.value else {
                    publisher.send(completion: .failure(RequestError.cookieNotFound))
                    return
                }
                
                publisher.send(cookieValue)
                publisher.send(completion: .finished)
                
            case .failure(let error):
                publisher.send(completion: .failure(RequestError.sessionFailed(error: error)))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
    
//    [<NSHTTPCookie
//       version:0
//       name:user_session
//       value:deleted
//       expiresDate:'2019-12-12 15:49:18 +0000'
//       created:'2019-12-12 15:49:18 +0000'
//       sessionOnly:FALSE
//       domain:secure.nicovideo.jp
//       partition:none
//       sameSite:none
//       path:/
//       isSecure:FALSE
//    path:"/" isSecure:FALSE>, <NSHTTPCookie
//       version:0
//       name:user_session
//       value:user_session_17325035_fef759fb91eb7b48108313e17273736d8685f53746886852fc9735c24b6bb476
//       expiresDate:'2020-01-11 15:49:17 +0000'
//       created:'2019-12-12 15:49:18 +0000'
//       sessionOnly:FALSE
//       domain:.nicovideo.jp
//       partition:none
//       sameSite:none
//       path:/
//       isSecure:FALSE
//    path:"/" isSecure:FALSE>, <NSHTTPCookie
//       version:0
//       name:user_session_secure
//       value:MTczMjUwMzU6SjNsblcwc2RucldHRGxJLmRPSkZBZ0VWa1htREk5ajV5V1NneFNMbUlEWQ
//       expiresDate:'2020-01-11 15:49:17 +0000'
//       created:'2019-12-12 15:49:18 +0000'
//       sessionOnly:FALSE
//       domain:.nicovideo.jp
//       partition:none
//       sameSite:none
//       path:/
//       isSecure:TRUE
//       isHTTPOnly: YES
//    path:"/" isSecure:TRUE isHTTPOnly: YES>, <NSHTTPCookie
//       version:0
//       name:registrationActionTrackId
//       value:
//       expiresDate:'2019-12-11 15:49:18 +0000'
//       created:'2019-12-12 15:49:18 +0000'
//       sessionOnly:FALSE
//       domain:.nicovideo.jp
//       partition:none
//       sameSite:none
//       path:/
//       isSecure:TRUE
//       isHTTPOnly: YES
//    path:"/" isSecure:TRUE isHTTPOnly: YES>]
