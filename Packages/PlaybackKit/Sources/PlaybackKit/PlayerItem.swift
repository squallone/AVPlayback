//
//  PlayerItem.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

public struct PlayerItem: Sendable, Equatable {
    public let source: PlaybackSource
    public let options: PlaybackOptions
    public let drm: DRM?
    
    public init(source: PlaybackSource, options: PlaybackOptions, drm: DRM? = nil) {
        self.source = source
        self.options = options
        self.drm = drm
    }
}
