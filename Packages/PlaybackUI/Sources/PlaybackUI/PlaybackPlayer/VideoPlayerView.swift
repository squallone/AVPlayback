//
//  VideoPlayerView.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation
import SwiftUI

public struct VideoPlayerView: View {
    
    private let viewModel: VideoPlayerViewModel
    
    init(viewModel: VideoPlayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VideoPlayerSurface(player: viewModel.player)
                .ignoresSafeArea()
            
            if let error = viewModel.activeError {
                VideoPlayerErrorOverlay(error: error) {
                    viewModel.load()
                }
            }
            
            VStack {
                HStack {
                    Text("Example")
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    if viewModel.status == .buffering || viewModel.status == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    }
                }
                
                Spacer()
                
                PlayerControls(
                    status: viewModel.status,
                    currentTime: viewModel.currentTime,
                    duration: viewModel.duration,
                    buffer: viewModel.bufferProgress,
                    onPlayPause: viewModel.togglePlayPause,
                    onScrubStart: viewModel.startScrubbing,
                    onScrubEnd: viewModel.endScrubbing
                )
            }
        }
        .task {
            viewModel.load()
        }
    }
}

#Preview {
    //VideoPlayerView(viewModel: VideoPlayerFactory.makeViewModel(url: URL(string: "http://23.237.104.106:8080/USA_CBS_SPORTS/index.m3u8")!))
}
