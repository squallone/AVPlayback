//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

public struct PlayerError: Error {
    let id = UUID()
    let category: Category
    let message: String
    let originalError: NSError?
}

public extension PlayerError {
    enum Category: String, Equatable {
        case network
        case decoding
        case unknown
        case resource
        case authentication
    }
}
