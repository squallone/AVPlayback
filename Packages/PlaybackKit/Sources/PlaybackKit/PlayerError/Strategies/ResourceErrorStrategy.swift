//
//  ResourceErrorStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

struct ResourceErrorStrategy: ErrorMappingStrategy {
    func map(_ error: Error) -> PlayerError? {
        let nsError = error as NSError
        
        let isCocoaMissing = nsError.domain == NSCocoaErrorDomain && nsError.code == NSFileNoSuchFileError
        let isUrlMissing = nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorFileDoesNotExist
        
        if isCocoaMissing || isUrlMissing {
            return PlayerError(
                category: .resource,
                message: "Video not found",
                originalError: nsError
            )
        }
        return nil
    }
}
