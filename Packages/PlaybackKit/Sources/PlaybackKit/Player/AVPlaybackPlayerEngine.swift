//
//  File.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import AVFoundation
import Combine
import Foundation
#if canImport(AVFAudio)
import AVFAudio
#endif

final class AVPlaybackPlayerEngine: PlayerEngine {
    private let player: AVPlayer
    private let eventSubject = PassthroughSubject<PlayerEvent, Never>()
    private let errorMapper: ErrorMapper
    
    private var timeObserver: Any?
    private var cancellables: Set<AnyCancellable> = []
    
    var eventPublisher: AnyPublisher<PlayerEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    // MARK: Life Cycle
    
    init(errorMapper: ErrorMapper = ErrorMapper()) {
        self.player = .init()
        self.errorMapper = errorMapper
        startObservingPlayer()
    }
    
    deinit {
        if let timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    // MARK: PlayerEngine Methods
    
    func load(item playerItem: PlayerItem) {
        let avPlayerItem = AVPlayerItem(url: playerItem.url)
        avPlayerItem.preferredForwardBufferDuration = playerItem.preferredForwardBufferDuration
        
        player.replaceCurrentItem(with: avPlayerItem)
        broadcast(event: .state(.statusChanged(.loading)))
        observePlayerItem(avPlayerItem)
    }
    
    func play() {
        startAudioSession()
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func setRate(_ rate: Float) {
        player.rate = rate
    }
    
    func seek(to time: TimeInterval) async {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        await player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK: Internal Logic
    
    private func broadcast(event: PlayerEvent) {
        eventSubject.send(event)
    }
    
    private func startAudioSession() {
        #if os(macOS)
        // AVAudioSession is unavailable on macOS; no-op
        #else
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    
    // MARK: Observers

    private func observePlayerItem(_ item: AVPlayerItem) {
        item.publisher(for: \.duration)
            .sink { [weak self] duration in
                guard let self = self else { return }
                let seconds = duration.seconds
                if !seconds.isNaN {
                    self.broadcast(event: .state(.durationChanged(seconds)))
                    self.broadcast(event: .state(.statusChanged(.readyToPlay)))
                }
            }
            .store(in: &cancellables)
        
        item.publisher(for: \.loadedTimeRanges)
            .sink { [weak self] ranges in
                guard let self else { return }
                guard let durationInSeconds = self.player.currentItem?.duration.seconds, !durationInSeconds.isNaN, durationInSeconds > 0 else { return }
                
                if let range = ranges.first?.timeRangeValue {
                    let buffered = (range.start.seconds + range.duration.seconds)  / durationInSeconds
                    self.broadcast(event: .state(.bufferedFractionChanged(buffered)))
                }
            }
            .store(in: &cancellables)
    }
    
    private func startObservingPlayer() {
        observePlayerStatus()
        observePlaybackTime()
        observePlaybackErrors()
    }
    
    private func observePlayerStatus() {
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                self?.handleStatusChange(status)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.broadcast(event: .state(.statusChanged(.finished)))
            }
            .store(in: &cancellables)
    }
    
    private func observePlaybackTime() {
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.broadcast(event: .state(.currentTimeChanged(time.seconds)))
        }
    }
    
    private func observePlaybackErrors() {
        
        player.publisher(for: \.currentItem?.status)
            .sink { [weak self] status in
                guard let self = self, status == .failed else { return }
                
                if let error = self.player.currentItem?.error {
                    let mapped = errorMapper.map(error)
                    broadcast(event: .error(mapped))

                }
            }
        
        NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime)
            .compactMap { notification -> PlayerError? in
                guard let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error else {
                    return nil
                }
                return self.errorMapper.map(error)
            }
            .sink { [weak self] error in
                self?.broadcast(event: .error(error))
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .AVPlayerItemNewErrorLogEntry)
            .compactMap { notification -> AVPlayerItem? in
                return notification.object as? AVPlayerItem
            }
            .compactMap { item -> PlayerError? in
                guard let event = item.errorLog()?.events.last else { return nil }
                return self.errorMapper.map(logEvent: event)
            }
            .sink { [weak self] error in
                self?.broadcast(event: .error(error))
            }
            .store(in: &cancellables)
    }
    
    // MARK: Handlers
    
    func handleStatusChange(_ status: AVPlayer.TimeControlStatus) {
        switch status {
        case .paused:
            if player.currentItem?.status == .readyToPlay {
                broadcast(event: .state(.statusChanged(.buffering)))
            }
        case .playing:
            broadcast(event: .state(.statusChanged(.playing)))
        case .waitingToPlayAtSpecifiedRate:
            broadcast(event: .state(.statusChanged(.buffering)))
        @unknown default:
            break
        }
    }
}

