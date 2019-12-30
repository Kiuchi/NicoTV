//
//  JSONDecoder.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    convenience init(_ keyDecodingStrategy: KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
    
}
