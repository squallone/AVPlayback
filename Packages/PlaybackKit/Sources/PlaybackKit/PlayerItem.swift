//
//  PlayerItem.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

public struct PlayerItem: Sendable, Equatable {
    public let url: URL
    public let preferredForwardBufferDuration: TimeInterval
    public let contentType: String?
}
