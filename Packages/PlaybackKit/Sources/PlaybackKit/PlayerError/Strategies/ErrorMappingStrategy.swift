//
//  ErrorMappingStrategy.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

protocol ErrorMappingStrategy {
    func map(_ error: Error) -> PlayerError?
}
