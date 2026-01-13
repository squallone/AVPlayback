//
//  ModernScrubber.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/12/26.
//

import SwiftUI

struct ModernScrubber: View {
    let value: Double
    let total: Double
    let buffer: Double
    let onDragStart: () -> Void
    let onDragEnd: (Double) -> Void
    
    @State private var isDragging: Bool = false
    @State private var dragLocation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 30)
                
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 4)
                
                Capsule()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: width(for: buffer, in: geo), height: 4)
                
                let currentWidth = width(for: value, in: geo)
                Capsule()
                    .fill(Color.red)
                    .frame(width: currentWidth, height: 4)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: isDragging ? 20 : 12, height: isDragging ? 20 : 12)
                    .shadow(radius: 4)
                    .offset(x: currentWidth - (isDragging ? 10 : 6))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { v in
                        if !isDragging {
                            isDragging = true
                            onDragStart()
                        }
                        // Calculate percentage
                        let pct = min(max(0, v.location.x / geo.size.width), 1)
                        // Note: We don't update 'value' directly here because that's owned by the parent/ViewModel
                        // In a real app, you might want a local @State for smooth dragging visual
                    }
                    .onEnded { v in
                        isDragging = false
                        let pct = min(max(0, v.location.x / geo.size.width), 1)
                        onDragEnd(pct * total)
                    }
            )
        }
        .frame(height: 30)
    }
    
    private func width(for timeVal: Double, in geo: GeometryProxy) -> CGFloat {
        guard total > 0 else { return 0 }
        let pct = CGFloat(timeVal / total)
        return geo.size.width * pct
    }
}

#Preview {
    ModernScrubber(
        value: 10,
        total: 100,
        buffer: 20,
        onDragStart: {
        },
        onDragEnd: { _ in }
    )
}
