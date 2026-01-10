//
//  MediaAsset+Metadata.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/1/26.
//
import Foundation

public extension MediaAsset {
    public struct Metadata: Sendable {
        public let title: String
        public let description: String?
        public let duration: TimeInterval?
        
        public init(title: String, description: String? = nil, duration: TimeInterval? = nil) {
            self.title = title
            self.description = description
            self.duration = duration
        }
    }
}
