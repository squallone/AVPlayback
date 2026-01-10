//
//  MediaAssetLoader.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/3/26.
//
import Foundation
import PlaybackKit

public struct MediaAssetLoader: Sendable {
    enum LoadError: Error {
        case missingResource
    }
    
    public init() {}
    
    func loadFromBundle(named fileName: String, withExtension ext: String) async throws -> [MediaAsset] {

        guard let url = Bundle.module.url(forResource: fileName, withExtension: ext) else {
#if DEBUG
            print("MediaAssetLoader: Could not find \(fileName).\(ext) in bundle")
#endif
            throw LoadError.missingResource
        }
        
        return try await Task.detached(priority: .utility) {
            let data = try Data(contentsOf: url)
            let assets = try JSONDecoder().decode([LocalMediaAsset].self, from: data)
            return assets.mapToMediaAssets()
        }.value
    }
}
