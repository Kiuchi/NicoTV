//
//  Sort.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

enum Sort : String, CaseIterable, Codable {
    case viewCountAscending     = "+viewCounter"
    case viewCountDescending    = "-viewCounter"
    case mylistCountAscending   = "+mylistCounter"
    case mylistCountDescending  = "-mylistCounter"
    case commentCountAscending  = "+commentCounter"
    case commentCountDescending = "-commentCounter"
    case postDateAscending      = "+startTime"
    case postDateDescending     = "-startTime"
    case lastCommentAscending   = "+lastCommentTime"
    case lastCommentDescending  = "-lastCommentTime"
    case movieLengthAscending   = "+lengthSeconds"
    case movieLengthDescending  = "-lengthSeconds"
}
