//
//  CoreMediaErrorStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

struct CoreMediaErrorStrategy: ErrorMappingStrategy {
    func map(_ error: Error) -> PlayerError? {
        let nsError = error as NSError
        if nsError.domain == "CoreMediaErrorDomain" {
            if nsError.code == -12884 {
                return PlayerError(
                    category: .authentication,
                    message: "DRM Protection Error",
                    originalError: nsError
                )
            }
        }
        return nil
    }
}
