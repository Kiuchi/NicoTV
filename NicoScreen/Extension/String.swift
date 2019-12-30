//
//  String.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/21.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

extension String {
    
    var urlEncode: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var urlDecode: String? {
        return self.removingPercentEncoding
    }
}
