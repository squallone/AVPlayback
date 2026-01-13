//
//  File.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation
import PlaybackKit
import SwiftUI

struct PlayerControls: View {
    let viewModel: VideoPlayerViewModel
    let onInteracting: (Bool) -> Void
    let onDismiss: () -> Void
    
    private var isAtLiveEdge: Bool {
        viewModel.duration - viewModel.currentTime < 10
    }
    
    var body: some View {
        ZStack {
            // Gradient Scrims
            VStack {
                LinearGradient(
                    colors: [.black.opacity(0.8), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 140)
                .allowsHitTesting(false)
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 180)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            
            // Main Controls Layout
            VStack {
                topControls()
                
                Spacer()
                
                HStack {
                    if viewModel.status == .buffering || viewModel.status == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        Button(action: viewModel.togglePlayPause) {
                            Image(systemName: viewModel.status == .playing ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundStyle(.white)
                                .shadow(radius: 10)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom Controls
                VStack(spacing: 12) {
                    HStack {
                        Button(action: {
                            viewModel.endScrubbing(at: viewModel.duration)
                        }) {
                            LiveBadgeView(isLive: isAtLiveEdge)
                        }
                        .disabled(isAtLiveEdge)
                        
                        Spacer()
                        
                        // Time Labels
                        HStack(spacing: 4) {
                            Text(format(viewModel.currentTime))
                            Text("/")
                                .opacity(0.5)
                            Text(format(viewModel.duration))
                        }
                        .font(.caption2.monospacedDigit())
                        .foregroundColor(.white.opacity(0.9))
                    }
                    
                    ModernScrubber(
                        value: viewModel.currentTime,
                        total: viewModel.duration,
                        buffer: viewModel.bufferProgress,
                        onDragStart: {
                            viewModel.startScrubbing()
                            onInteracting(true)
                        },
                        onDragEnd: { time in
                            viewModel.endScrubbing(at: time)
                            onInteracting(false)
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
            }
        }
    }
    
    fileprivate func topControls() -> some View {
        HStack(alignment: .center, spacing: 16) {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            VStack(alignment: .leading, spacing: 2)  {
                Text(viewModel.asset.metadata.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text("Live Stream")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image(systemName: "captions.bubble")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                
                AirPlayButton()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private func format(_ time: Double) -> String {
        // Handle NaN or Infinity safety
        guard !time.isNaN, !time.isInfinite else { return "00:00" }
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    PlayerControls(
        viewModel: VideoPlayerFactory().makeViewModel(asset: .stub()),
        onInteracting: { _ in },
        onDismiss: {}
    )
}
