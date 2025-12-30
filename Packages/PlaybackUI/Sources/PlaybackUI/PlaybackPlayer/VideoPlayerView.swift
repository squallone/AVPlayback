//
//  VideoPlayerView.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation
import SwiftUI

public struct VideoPlayerView: View {
    
    @State private var viewModel: VideoPlayerViewModel
    
    init(viewModel: VideoPlayerViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VideoPlayerSurface(player: viewModel.player)
                .ignoresSafeArea()
            
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
        .onAppear {
            viewModel.load()
        }
    }
}

#Preview {
    VideoPlayerView(viewModel: VideoPlayerFactory.makeViewModel(url: URL(string: "http://23.237.104.106:8080/USA_CBS_SPORTS/index.m3u8")!))
}
