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
            
            
            if viewModel.isAirPlayActive {
                VStack {
                    Image(systemName: "airplayvideo")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    Text("Playing on AirPlay")
                        .foregroundStyle(.gray)
                }
                .onTapGesture {
                    toggleControls()
                }
            } else {
                VideoPlayerSurface(
                    player: viewModel.player,
                    mode: viewModel.scaleMode
                )
                .ignoresSafeArea(edges: .vertical)
                .onTapGesture {
                    toggleControls()
                }
                .onTapGesture(count: 2) {
                    withAnimation {
                        viewModel.toggleScaleMode()
                    }
                }
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
            
            VStack {
                Spacer()
                if viewModel.videoSize != .zero {
                    Text("Res: \(Int(viewModel.videoSize.width))x\(Int(viewModel.videoSize.height))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 50)
                }
            }
        }
#if os(iOS)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
#elseif os(macOS)
        // Hides the back button area completely
        .toolbar(.hidden, for: .windowToolbar)
        // Hides the navigation title area
        .navigationTitle("")
#endif
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

