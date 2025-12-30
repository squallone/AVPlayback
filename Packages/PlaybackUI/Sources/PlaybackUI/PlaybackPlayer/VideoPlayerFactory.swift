//
//  PlayerContainer.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation
import PlaybackKit

@MainActor
public struct VideoPlayerFactory {
    public static func makeVideoPlayer(url: URL) -> VideoPlayerView {
        VideoPlayerView(viewModel: makeViewModel(url: url))
    }
    
    static func makeViewModel(url: URL) -> VideoPlayerViewModel {
        VideoPlayerViewModel(
            url: url,
            player: PlayerFactory.make()
        )
    }
}
