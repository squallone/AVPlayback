//
//  DebuggerPlugin.swift
//  PlaybackKit
//
//  Created by Abdiel Soto on 12/29/25.
//

import Foundation

struct DebuggerPlugin: PlayerPlugin {
    
    init() {
        
    }
    
    func onEvent(_ event: PlayerEvent, engine: any PlayerEngine) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        
        switch event {
        case .state(let state):
            handleState(state)
        case .error(let error):
            print("❌ [\(timestamp)] Error: \(error.message)")
        @unknown default:
            break
        }
    }
    
    private func handleState(_ state: PlayerStateChange) {
        switch state {
        case .statusChanged(let status):
            if case .idle = status {
                print("⚠️ Player went Idle. Checking Engine...")
            }
        @unknown default: break
        }
    }
}
