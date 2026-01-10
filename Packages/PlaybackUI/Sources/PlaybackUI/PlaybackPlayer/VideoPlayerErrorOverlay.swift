//
//  VideoPlayerErrorOverlay.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/10/26.
//

import SwiftUI
import PlaybackKit

struct VideoPlayerErrorOverlay: View {
    
    let error: PlayerError
    let onRetry: () -> Void

    var iconName: String {
        switch error.category {
        case .network: return "wifi.slash"
        case .authentication: return "lock.slash.fill"
        case .resource: return "externaldrive.badge.xmark"
        default: return "exclamationmark.triangle"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: iconName)
                    .font(.system(size: 50))
                    .foregroundStyle(.red)
                Text("Playback Error")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(error.userFriendlyMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
                if error.category == .network {
                    Button(action: onRetry) {
                        Text("Try again")
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                    }
                }
                
                if let originalError = error.originalError {
                    Text("\(originalError.localizedDescription) \n \(originalError.localizedFailureReason ?? "")")
                        .font(.caption2)
                        .foregroundStyle(.gray.opacity(0.9))
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                }
                
            }
        }
    }
}

#Preview {
    VideoPlayerErrorOverlay(error: ErrorMapper().map(NSError(
        domain: URLError.errorDomain,
        code: URLError.notConnectedToInternet.rawValue,
        userInfo: [
            NSLocalizedDescriptionKey: "The internet connection appears to be offline.",
            NSURLErrorFailingURLStringErrorKey: "https://api.myapp.com/video/123"
        ]
    )), onRetry: {})
}
