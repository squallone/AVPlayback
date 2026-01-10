//
//  MediaAsset+PlaybackOptions.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/1/26.
//
import Foundation

public struct PlaybackOptions: Sendable, Equatable {
    public let prefferedPeakBitrate: Double?
    public let prefferedForwardBufferDuration: TimeInterval
    
    public init(
        prefferedPeakBitrate: Double? = nil,
        prefferedForwardBufferDuration: TimeInterval = 10.0,
    ) {
        self.prefferedPeakBitrate = prefferedPeakBitrate
        self.prefferedForwardBufferDuration = prefferedForwardBufferDuration
    }
}
