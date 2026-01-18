//
//  PlayerEvent.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/28/25.
//

import Foundation

public enum PlayerEvent {
    case state(PlayerStateChange)
    case lifecycle(LifecycleEvent)
    case diagnostics
    case videoSizeChanged(CGSize)
    case airPlayStatusChanged(Bool)
    case error(PlayerError)
}
