//
//  PlayerEvent.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/28/25.
//

import Foundation

enum PlayerEvent {
    case state(PlayerStateChange)
    case lifecycle(LifecycleEvent)
    case diagnostics
    case error(PlayerError)
}
