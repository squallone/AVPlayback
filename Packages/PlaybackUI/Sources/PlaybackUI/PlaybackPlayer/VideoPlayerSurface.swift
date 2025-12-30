//
//  VideoPlayerSurface.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/29/25.
//

import AVFoundation
import Foundation
import PlaybackKit
import SwiftUI

final class PlayerLayerView: NativeView {
    
    let player: PlayerEngine
    
#if !os(macOS)
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
#endif
    
    var playerLayer: AVPlayerLayer? {
        layer as? AVPlayerLayer
    }
    
    init(player: PlayerEngine) {
        self.player = player
        super.init(frame: .zero)
        
        guard let provider = player as? AVPlayerProvider else {
            return
        }
        
#if os(macOS)
        // macOS: Views are not layer-backed by default
        // We must create the layer manually and set wantsLayer
        let layer = AVPlayerLayer(player: provider.player)
        layer.videoGravity = .resizeAspectFill
        self.layer = layer
        wantsLayer = true
#else
        playerLayer?.player = provider.player
        playerLayer?.videoGravity = .resizeAspectFill
#endif
        self.playerLayer?.videoGravity = .resizeAspectFill
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct VideoPlayerSurface: NativeViewRepresentable {
    let player: PlayerEngine
    
#if os(macOS)
    func makeNSView(context: Context) -> NSView {
        PlayerLayerView(player: player)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
    }
#endif
    
#if os(iOS) || os(tvOS)
    func makeUIView(context: Context) -> UIView {
        PlayerLayerView(player: player)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
#endif
}
