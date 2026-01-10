//
//  ErrorMappingStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

public protocol ErrorMappingStrategy: Sendable {
    func map(_ error: Error) -> PlayerError?
}
