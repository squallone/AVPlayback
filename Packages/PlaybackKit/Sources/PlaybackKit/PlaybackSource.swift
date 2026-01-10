//
//  PlaybackSource.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 1/2/26.
//
import Foundation

public struct PlaybackSource: Sendable, Equatable {
    public let url: URL
    public let isLive: Bool
    public let drm: String?
    
    public init(url: URL, isLive: Bool, drm: String? = nil) {
        self.url = url
        self.isLive = isLive
        self.drm = drm
    }
}
