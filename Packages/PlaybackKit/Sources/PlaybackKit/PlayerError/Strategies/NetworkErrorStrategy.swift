//
//  NetworkErrorStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//
import Foundation

struct NetworkErrorStrategy: ErrorMappingStrategy {
    
    func map(_ error: Error) -> PlayerError? {
        let nsError = error as NSError
        guard nsError.domain == URLError.errorDomain else { return nil }
        
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            return PlayerError(
                category: .network,
                message: "No Internet Connection",
                originalError: nsError
            )
            
        default:
            return PlayerError(
                category: .network,
                message: error.localizedDescription,
                originalError: nsError
            )
        }
    }
}
