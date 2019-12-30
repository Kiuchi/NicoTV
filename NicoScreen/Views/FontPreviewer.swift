//
//  FontPreviewer.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/22.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI

struct FontPreviewer: View {
    var body: some View {
        VStack {
            Text("LargeTitle").font(.largeTitle)
            Text("Title").font(.title)
            Text("Headline").font(.headline)
            Text("Subheadline").font(.subheadline)
            Text("Body").font(.body)
            Text("Callout").font(.callout)
            Text("Caption").font(.caption)
            Text("Footnote").font(.footnote)
        }
    }
}

struct FontPreviewer_Previews: PreviewProvider {
    static var previews: some View {
        FontPreviewer()
        .previewLayout(.fixed(width: 500, height: 500))
    }
}

/*
 static let largeTitle: Font
 A font with the large title text style.
 static let title: Font
 A font with the title text style.
 static var headline: Font
 A font with the headline text style.
 static var subheadline: Font
 A font with the subheadline text style.
 static var body: Font
 A font with the body text style.
 static var callout: Font
 A font with the callout text style.
 static var caption: Font
 A font with the caption text style.
 static var footnote: Font
 A font with the footnote text style.
 */
