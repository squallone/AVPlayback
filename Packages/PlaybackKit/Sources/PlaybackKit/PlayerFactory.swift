//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation

public protocol PlayerBulding {
    func makePlayer() -> PlayerEngine
}

public struct PlayerFactory: PlayerBulding {
    public init() {}
    public func makePlayer() -> PlayerEngine {
        AVPlaybackPlayerEngine(
            plugins: [
                DebuggerPlugin()
            ],
            sessionConfiguration: PlaybackSessionConfiguration(allowsBackgroundPlayback: true)
        )
    }
}
