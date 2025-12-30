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
           
        }
        .onAppear {
            viewModel.load()
        }
        
    }
    
}

#Preview {
    VideoPlayerView(viewModel: VideoPlayerFactory.makeViewModel(url: URL(string: "http://23.237.104.106:8080/USA_CBS_SPORTS/index.m3u8")!))
}
