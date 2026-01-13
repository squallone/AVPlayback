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
        VideoPlayerView(
            viewModel: makeViewModel(asset: asset)
        )
    }
}

extension VideoPlayerFactory {
    func makeViewModel(asset: MediaAsset) -> VideoPlayerViewModel {
        VideoPlayerViewModel(
            asset: MediaAsset(
                source: PlaybackSource(
                    url: asset.source.url,
                    isLive: asset.source.isLive
                ),
                metadata: MediaAsset.Metadata(
                    title: asset.metadata.title,
                    description: nil,
                    duration: nil
                ),
                playback: PlaybackOptions()
            ),
            player: playerFactory.makePlayer()
        )
    }
}
