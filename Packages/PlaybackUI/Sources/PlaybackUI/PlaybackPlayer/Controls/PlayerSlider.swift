//
//  File.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/30/25.
//

import Foundation
import SwiftUI

struct PlayerSlider: View {
    let value: Double
    let total: Double
    let buffer: Double
    let onDragStart: () -> Void
    let onDragEnd: (Double) -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 4)
                // Buffer
                Rectangle().fill(Color.white.opacity(0.3))
                    .frame(width: geo.size.width * CGFloat(buffer), height: 4)
                // Progress
                Rectangle().fill(Color.red)
                    .frame(width: width(geo.size.width), height: 4)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { v in
                        onDragStart()
                    }
                    .onEnded { v in
                        let pct = min(max(0, v.location.x / geo.size.width), 1)
                        onDragEnd(pct * total)
                    }
            )
        }
        .frame(height: 20)
    }
    
    private func width(_ totalWidth: CGFloat) -> CGFloat {
        guard total > 0 else { return 0 }
        return totalWidth * CGFloat(value / total)
    }
}
