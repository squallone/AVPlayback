//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation

public struct PlayerFactory {
    public static func make() -> PlayerEngine {
        AVPlaybackPlayerEngine()
    }
}
