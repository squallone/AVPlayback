//
//  VideoPlayerViewModel.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation
import PlaybackKit
import Combine

@Observable
@MainActor
final class VideoPlayerViewModel {
    
    // UI
    var status: PlayerStatus = .idle
    var currentTime: Double = 0
    var duration: Double = 0
    var bufferProgress: Double = 0
    var currentItem: PlayerItem?
    var activeError: PlayerError?
    
    var scaleMode: VideoScaleMode = .fill
    var videoSize: CGSize = .zero
    var videoAspectRatio: CGFloat {
        guard videoSize.height > 0 else { return 16/9 }
        return videoSize.width / videoSize.height
    }
    
    @ObservationIgnored
    private(set) var player: PlayerEngine
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored
    private var isScrubbing = false
    @ObservationIgnored
    let asset: MediaAsset
    
    // MARK: Initialization
    init(asset: MediaAsset, player: PlayerEngine) {
        self.player = player
        self.asset = asset
        startObservingPlayer()
    }
    
    // MARK: Observers
    
    private func startObservingPlayer() {
        player.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Events
    
    private func handleEvent(_ event: PlayerEvent) {
        switch event {
        case .state(let stateChange):
            handleStateChange(stateChange)
        case .videoSizeChanged(let size):
            self.videoSize = size
        case .error(let error):
            self.activeError = error
            
        @unknown default:
            break
        }
    }
    
    private func handleStateChange(_ state: PlayerStateChange) {
        switch state {
        case .statusChanged(let status):
            if status == .playing {
                activeError = nil
            }
            self.status = status
        case .currentTimeChanged(let time):
            if !isScrubbing {
                self.currentTime = time
            }
        case .durationChanged(let duration):
            self.duration = duration
        case .bufferedFractionChanged(let fraction):
            self.bufferProgress = fraction
        case .rateChanged(_):
            break
        }
    }
    
    // MARK: Scale Mode
    
    func toggleScaleMode() {
        scaleMode = scaleMode == .fit ? .fill : .fit
    }
    
    // MARK: Scrubbing
    
    func startScrubbing() {
        isScrubbing = true
    }
    
    func endScrubbing(at time: Double) {
        Task {
            await player.seek(to: time)
            try? await Task.sleep(nanoseconds: 100_000_000)
            isScrubbing = false
        }
    }
    
    // MARK: Player Handling
    func load() {
        let item = PlayerItem(
            source: PlaybackSource(url: asset.source.url, isLive: true, drm: nil),
            options: PlaybackOptions()
        )
        self.currentItem = item
        
        player.load(item: item)
        player.play()
    }
    
    func togglePlayPause() {
        if status == .playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
}
