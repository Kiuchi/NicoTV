//
//  Term.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

enum Term: String, Codable {
    case total
    case monthly
    case weekly
    case daily = "24h"
    case hourly
}
