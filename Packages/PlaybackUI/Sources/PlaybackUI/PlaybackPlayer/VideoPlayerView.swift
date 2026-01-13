//
//  VideoPlayerView.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation
import SwiftUI

public struct VideoPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let viewModel: VideoPlayerViewModel
    
    @State private var areControlsVisible: Bool = true
    @State private var hideTimer: Timer?
    
    init(viewModel: VideoPlayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VideoPlayerSurface(player: viewModel.player)
                .ignoresSafeArea()
                .onTapGesture {
                    toggleControls()
                }
            
            if let error = viewModel.activeError {
                VideoPlayerErrorOverlay(error: error) {
                    viewModel.load()
                }
                .transition(.opacity)
            }
            
            if areControlsVisible {
                PlayerControls(viewModel: viewModel) { isInteracting in
                    if isInteracting {
                        cancelHideTimer()
                    } else {
                        scheduleHideTimer()
                    }
                } onDismiss: {
                    dismiss()
                }
                .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            viewModel.load()
            scheduleHideTimer()
        }
    }
    
    private func toggleControls() {
        withAnimation {
            areControlsVisible.toggle()
        }
        
        if areControlsVisible {
            scheduleHideTimer()
        } else {
            cancelHideTimer()
        }
    }
    
    private func scheduleHideTimer() {
        cancelHideTimer()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
            withAnimation {
                areControlsVisible = false
            }
        }
    }
    
    private func cancelHideTimer() {
        hideTimer?.invalidate()
        hideTimer = nil
    }
}

#Preview {
    VideoPlayerView(viewModel: VideoPlayerFactory().makeViewModel(asset: .stub()))
}
