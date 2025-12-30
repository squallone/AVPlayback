//
//  LifecycleEvent.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

public enum LifecycleEvent: Sendable, Equatable {
    case didLoad(item: PlayerItem)
    case didStartPlayback
    case didPause
    case didFinish
    case didReplay

    case didStall
    case didRecoverFromStall

    case didEndInterruption(shouldResume: Bool)

    case didStartPictureInPicture
    case didStopPictureInPicture
}
