//
//  SwiftUIView.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/12/26.
//

import SwiftUI

struct LiveBadgeView: View {
    let isLive: Bool
    
    @State private var pulse: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isLive ? .red : .gray)
                .frame(width: 8, height: 8)
                .opacity(isLive ? (pulse ? 1.0 : 0.5) : 1.0)
            
            Text("LIVE")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(isLive ? .white : .gray)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

#Preview {
    LiveBadgeView(isLive: true)
}
