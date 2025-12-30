//
//  PlayerState.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

enum PlayerStateChange: Sendable, Equatable {
    case statusChanged(PlayerStatus)
    case rateChanged(Float)
    case currentTimeChanged(TimeInterval)
    case bufferedFractionChanged(Double)
    case durationChanged(TimeInterval)
}
