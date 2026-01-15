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
    
    private var currentMode: VideoScaleMode
    
#if !os(macOS)
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
#endif
    
    var playerLayer: AVPlayerLayer? {
        layer as? AVPlayerLayer
    }
    
    init(player: PlayerEngine, mode: VideoScaleMode) {
        self.currentMode = mode
        super.init(frame: .zero)
        
        guard let provider = player as? AVPlayerProvider else {
            return
        }
        
#if os(macOS)
        // macOS: Views are not layer-backed by default
        // We must create the layer manually and set wantsLayer
        let playerLayer = AVPlayerLayer(player: provider.player)
        playerLayer.videoGravity = mode == .fit ? .resizeAspect : .resizeAspectFill
        playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        self.layer = playerLayer
        wantsLayer = true
#else
        playerLayer?.player = provider.player
#endif
        applyMode(mode)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func update(mode: VideoScaleMode) {
        guard mode != self.currentMode else {
            return
        }
        
        currentMode = mode
        
#if os(iOS)
        UIView.animate(withDuration: 0.25) {
            self.applyMode(mode)
        }
#else
        applyMode(mode)
#endif
    }
    
    // MARK: Private
    
    private func applyMode(_ mode: VideoScaleMode) {
        let gravity: AVLayerVideoGravity = mode == .fit ? .resizeAspect : .resizeAspectFill
        playerLayer?.videoGravity = gravity
    }
}

struct VideoPlayerSurface: NativeViewRepresentable {
    let player: PlayerEngine
    let mode: VideoScaleMode
    
#if os(macOS)
    func makeNSView(context: Context) -> PlayerLayerView {
        PlayerLayerView(player: player, mode: mode)
    }
    
    func updateNSView(_ nsView: PlayerLayerView, context: Context) {
        nsView.update(mode: mode)
    }
#endif
    
#if os(iOS) || os(tvOS)
    func makeUIView(context: Context) -> PlayerLayerView {
        PlayerLayerView(player: player, mode: mode)
    }
    
    func updateUIView(_ uiView: PlayerLayerView, context: Context) {
        uiView.update(mode: mode)
    }
#endif
}
