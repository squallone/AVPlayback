//
//  PlaybackMediaList.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/3/26.
//

import SwiftUI

public struct PlaybackMediaListView: View {
    
    private let viewModel: PlaybackMediaListViewModel
    
    private let videoPlayerFactory: VideoPlayerBuilding
    
    public init(
        viewModel: PlaybackMediaListViewModel = PlaybackMediaListViewModel(),
        videoPlayerFactory: VideoPlayerBuilding = VideoPlayerFactory()
    ) {
        self.viewModel = viewModel
        self.videoPlayerFactory = videoPlayerFactory
    }
    
    public var body: some View {
        List(viewModel.assets) { asset in
            NavigationLink(value: asset) {
                VStack(alignment: .leading) {
                    Text(asset.metadata.title)
                        .font(.headline)
                    Text(asset.source.url.absoluteString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Channels")
        .navigationDestination(for: MediaAsset.self) { asset in
            videoPlayerFactory.makePlayer(asset: asset)
        }
        .task {
            await viewModel.loadAssets()
        }
    }
}

#Preview {
    PlaybackMediaListView(
        viewModel: PlaybackMediaListViewModel()
    )
}
