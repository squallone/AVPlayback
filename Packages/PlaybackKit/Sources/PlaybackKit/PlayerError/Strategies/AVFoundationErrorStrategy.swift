//
//  AVFoundationErrorStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//
import AVFoundation
import Foundation

struct AVFoundationErrorStrategy: ErrorMappingStrategy {
    func map(_ error: Error) -> PlayerError? {
        let nsError = error as NSError
        guard nsError.domain == AVFoundationErrorDomain else { return nil }
        
        switch nsError.code {
        case AVError.contentIsUnavailable.rawValue,
             AVError.unknown.rawValue:
            return PlayerError(
                category: .resource,
                message: "Video not found",
                originalError: nsError
            )
        case AVError.failedToParse.rawValue,
             AVError.formatUnsupported.rawValue,
             AVError.decoderNotFound.rawValue,
             AVError.decoderTemporarilyUnavailable.rawValue:
            return PlayerError(
                category: .decoding,
                message: "Corrupt or unsupported format",
                originalError: nsError
            )
        case AVError.noCompatibleAlternatesForExternalDisplay.rawValue:
            return PlayerError(
                category: .decoding,
                message: "Cannot play on this external display",
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
