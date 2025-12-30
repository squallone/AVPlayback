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
    let status: PlayerStatus
    let currentTime: Double
    let duration: Double
    let buffer: Double
    let onPlayPause: () -> Void
    let onScrubStart: () -> Void
    let onScrubEnd: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(format(currentTime))
                    .font(.caption)
                    .foregroundColor(.white)
                
                PlayerSlider(
                    value: currentTime,
                    total: duration,
                    buffer: buffer,
                    onDragStart: onScrubStart,
                    onDragEnd: onScrubEnd
                )
                
                Text(format(duration))
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
                    
            Button(action: onPlayPause) {
                Image(systemName: status == .playing ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
        )
    }
    
    private func format(_ time: Double) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

