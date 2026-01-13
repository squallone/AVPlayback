//
//  MediaAsset.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/1/26.
//

import Foundation
import PlaybackKit

public struct MediaAsset: Identifiable, Sendable, Hashable, Equatable {
    public let id = UUID()
    public let source: PlaybackSource
    public let metadata: Metadata
    public let playback: PlaybackOptions
    
    public init(
        source: PlaybackSource,
        metadata: MediaAsset.Metadata,
        playback: PlaybackOptions
    ) {
        self.source = source
        self.metadata = metadata
        self.playback = playback
    }
    
    public static func == (lhs: MediaAsset, rhs: MediaAsset) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MediaAsset {
    struct LiveConfiguration {
        let targetLatency: TimeInterval
        let maxDriftAllowed: TimeInterval
        let enableRateCatchup: Bool
    }
}

extension MediaAsset {
    static func stub() -> MediaAsset {
        MediaAsset(
            source: PlaybackSource(
                url: URL("http://example.com/video.mp4")!,
                isLive: true
            ),
            metadata: MediaAsset.Metadata(title: "NBC News"),
            playback: PlaybackOptions()
        )
    }
}

