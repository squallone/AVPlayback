//
//  PlaybackMediaListViewModel.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/3/26.
//
import Foundation
import PlaybackKit
import SwiftUI

@MainActor
@Observable
public final class PlaybackMediaListViewModel {
    var assets: [MediaAsset] = []
    var isLoading: Bool = false
    var error: Error? = nil
    
    @ObservationIgnored
    private let loader: MediaAssetLoader
    
    public init(loader: MediaAssetLoader = .init()) {
        self.loader = loader
    }
    
    func loadAssets() async {
        do {
            assets = try await loader.loadFromBundle(
                named: "MediaAssets",
                withExtension: "json"
            )
        } catch {
            print("PlaybackMediaListViewModel: Failed to load assets: \(error)")
            self.error = error
        }
    }
}
