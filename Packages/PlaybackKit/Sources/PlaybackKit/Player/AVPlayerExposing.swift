//
//  AVPlayerExposing.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/30/25.
//

import AVFoundation
import Foundation

public protocol AVPlayerProvider {
    var player: AVPlayer { get }
}
