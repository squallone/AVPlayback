//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

protocol PlayerPlugin {
    func onEvent(_ event: PlayerEvent, engine: PlayerEngine)
}
