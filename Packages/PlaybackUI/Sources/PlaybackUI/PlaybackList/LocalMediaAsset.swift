//
//  LocalMediaAsset.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/3/26.
//
import Foundation
import PlaybackKit

struct LocalMediaAsset: Codable {
    let title: String
    let url: String
}

extension [LocalMediaAsset] {
    func mapToMediaAssets() -> [MediaAsset] {
        compactMap { asset in
            guard let url = URL(string: asset.url) else {
                return nil
            }
            let asset = MediaAsset(
                source: PlaybackSource(url: url, isLive: true),
                metadata: MediaAsset.Metadata(title: asset.title),
                playback: PlaybackOptions()
            )
            
            return asset
        }
    }
}
