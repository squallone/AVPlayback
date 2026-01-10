//
//  ErrorMapper.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation
import AVFoundation

public struct ErrorMapper {
    
    private let strategies: [ErrorMappingStrategy]
    
    private static let defaultStragies: [ErrorMappingStrategy] = [
        NetworkErrorStrategy(),
        AVFoundationErrorStrategy(),
        ResourceErrorStrategy(),
        CoreMediaErrorStrategy()
    ]
    
    public init() {
        self.init(strategies: Self.defaultStragies)
    }
    
    init(strategies: [ErrorMappingStrategy]) {
        self.strategies = strategies
    }
    
    public func map(_ error: Error?) -> PlayerError {
        guard let error else {
            return PlayerError(category: .unknown, message: "Unknown error occurred", originalError: nil)
        }
        for strategy in strategies {
            if let mappedError = strategy.map(error) {
                return mappedError
            }
        }
        
        let nsError = error as NSError
        return PlayerError(category: .unknown, message: nsError.localizedDescription, originalError: nsError)
    }
}


extension ErrorMapper {
    func map(logEvent event: AVPlayerItemErrorLogEvent) -> PlayerError? {
        guard event.errorStatusCode >= 400 else { return nil }
        
        let message = "Segment Error: \(event.errorComment ?? "HTTP \(event.errorStatusCode)")"
        let category: PlayerError.Category = (event.errorStatusCode == 403 || event.errorStatusCode == 401) ? .authentication : .network
        
        let nsError = NSError(
            domain: "HTTPError",
            code: event.errorStatusCode,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
        
        return PlayerError(category: category, message: message, originalError: nsError)
    }
}
