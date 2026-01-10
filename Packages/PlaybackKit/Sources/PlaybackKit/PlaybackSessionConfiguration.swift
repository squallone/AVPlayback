//
//  PlaybackSessionConfiguration.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 1/2/26.
//

public struct PlaybackSessionConfiguration: Sendable {
    public let allowsBackgroundPlayback: Bool
    
    public init(allowsBackgroundPlayback: Bool) {
        self.allowsBackgroundPlayback = allowsBackgroundPlayback
    }
}
