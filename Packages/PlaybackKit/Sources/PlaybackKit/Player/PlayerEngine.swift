//
//  PlayerEngine.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/28/25.
//

import Combine
import Foundation

public protocol PlayerEngine {
    var eventPublisher: AnyPublisher<PlayerEvent, Never> { get }
    
    func load(item: PlayerItem)
    func play()
    func pause()
    @MainActor
    func seek(to time: TimeInterval) async
    func setRate(_ rate: Float)
}
