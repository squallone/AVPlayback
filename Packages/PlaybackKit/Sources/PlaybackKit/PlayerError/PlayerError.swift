//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

public struct PlayerError: Error {
    let id = UUID()
    public let category: Category
    public let message: String
    public let originalError: NSError?
}

public extension PlayerError {
    enum Category: String, Equatable {
        case network
        case decoding
        case unknown
        case resource
        case authentication
    }
    
    public var userFriendlyMessage: String {
        switch category {
        case .network: return "We are having trouble connecting to the internet."
        case .decoding: return "We cannot play this video format."
        case .authentication: return "You do not have permission to watch this."
        case .resource: return "This video is currently unavailable."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
