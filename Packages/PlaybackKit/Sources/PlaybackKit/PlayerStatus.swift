//
//  PlayerStatus.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/28/25.
//

import Foundation

enum PlayerStatus: Equatable {
    case idle
    case playing
    case paused
    case loading
    case readyToPlay
    case buffering
    case failed
    case finished
}
