//
//  PlayerContainer.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation
import PlaybackKit
import SwiftUI

@MainActor
public protocol VideoPlayerBuilding {
    @ViewBuilder func makePlayer(asset: MediaAsset) -> VideoPlayerView
}

@MainActor
public struct VideoPlayerFactory: VideoPlayerBuilding {
    
    private let playerFactory: PlayerBulding
    
    public init(playerFactory: PlayerBulding = PlayerFactory()) {
        self.playerFactory = playerFactory
    }
    
    public func makePlayer(asset: MediaAsset) -> VideoPlayerView {
        VideoPlayerView(viewModel: makeViewModel(url: asset.source.url))

    }
    
    func makeViewModel(url: URL) -> VideoPlayerViewModel {
        VideoPlayerViewModel(
            asset: MediaAsset(
                source: PlaybackSource(url: url, isLive: true),
                metadata: MediaAsset.Metadata(title: "Test", description: nil, duration: nil),
                playback: PlaybackOptions()
            ),
            player: playerFactory.makePlayer()
        )
    }
}
