//
//  Ranking.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/08.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import Foundation

struct Ranking: Codable {
    var genre: Genre
    var term: Term
    var movies: [Movie]
    
    struct Movie: Codable {
        var rank: Int
        var title: String
        var link: String
        var description: String
        var thumbnailURL: URL?
        var length: String?
        var postDate: String?
        var viewCount: Int
        var mylistCount: Int
        var commentCount: Int
        var id: String? { MovieID(url: link)?.text }
    }
}

struct MovieID {
    var suffix: IDSuffix = .sm
    var value: Int = 0
    var text: String
    
    init?(idString: String) {
        text = idString
    }
    
    init?(url: String) {
        guard let id = URL(string: url)?.lastPathComponent else {
            return nil
        }
        text = id
    }
}

enum IDSuffix: String {
    case sm
}

/*
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
 <channel>
     
    <title>動画ランキング - ニコニコ動画</title>
    <link>https://www.nicovideo.jp/ranking/genre/all?term=24h</link>
    <description>毎時更新</description>
    <pubDate>Wed, 05 Jun 2019 15:00:00 +0900</pubDate>
    <lastBuildDate>Wed, 05 Jun 2019 15:00:00 +0900</lastBuildDate>
    <generator>ニコニコ動画</generator>
    <language>ja-jp</language>
    <copyright>(c) DWANGO Co., Ltd.</copyright>
    <docs>http://blogs.law.harvard.edu/tech/rss</docs>

    <item>
        <title>新・豪血寺一族 -煩悩解放 - レッツゴー！陰陽師</title>
        <link>https://www.nicovideo.jp/watch/sm9</link>
        <guid isPermaLink="false">tag:nicovideo.jp,2007-03-06:/watch/sm9</guid>
        <pubDate>Fri, 07 Jun 2019 06:00:00 +0900</pubDate>
        <description><![CDATA[
            <p class="nico-thumbnail"><img alt="新・豪血寺一族 -煩悩解放 - レッツゴー！陰陽師" src="http://tn.smilevideo.jp/smile?i=9" width="94" height="70" border="0"/></p>
            <p class="nico-description">レッツゴー！陰陽師（フルコーラスバージョン）</p>
            <p class="nico-info"><small>
                <strong class="nico-info-length">5:20</strong>｜
                <strong class="nico-info-date">2007年03月06日 00：33：00</strong> 投稿<br/>
                <strong>合計</strong>
                &nbsp;&#x20;再生：<strong class="nico-info-total-view">17,970,370</strong>
                &nbsp;&#x20;コメント：<strong class="nico-info-total-res">4,826,765</strong>
                &nbsp;&#x20;マイリスト：<strong class="nico-info-total-mylist">176,356</strong><br/>
            </small></p>
        ]]></description>
    </item>
 </channel>
</rss>
 */
