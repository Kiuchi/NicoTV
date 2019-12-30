//
//  Genre.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

enum Genre: String, Codable {
    case all
    case anime
    case game
    case music
    case sing
    case dance
    case vocaloid
    case entertainment = "ent"
    
    var name: String {
        switch self {
        case .all: return "ALL"
        case .anime: return "アニメ"
        case .game: return "ゲーム"
        case .music: return "音楽"
        case .sing: return "歌ってみた"
        case .dance: return "踊ってみた"
        case .vocaloid: return "ボーカロイド"
        case .entertainment: return "エンターテイメント"
        }
    }
}
