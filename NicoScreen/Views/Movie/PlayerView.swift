//
//  PlayerView.swift
//  NicoScreen
//
//  Created by Yu Kiuchi on 2019/12/11.
//  Copyright © 2019 mattyaphone. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    @Binding var playerItem: AVPlayerItem?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer()
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        controller.modalPresentationStyle = .fullScreen
        controller.player?.replaceCurrentItem(with: playerItem)
        controller.player?.play()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static let playerItem = AVPlayerItem(url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)

    static var previews: some View {
        return PlayerView(playerItem: .constant(playerItem))
    }
}
