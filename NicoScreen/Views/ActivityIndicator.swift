//
//  ActivityIndicator.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/15.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    private let view = UIActivityIndicatorView(style: .large)

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        view.color = UIColor.white
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
    
    func color(_ color: UIColor) -> Self {
        view.color = color
        return self
    }
    
    func style(_ style: UIActivityIndicatorView.Style) -> Self {
        view.style = style
        return self
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isAnimating: .constant(true))
    }
}
