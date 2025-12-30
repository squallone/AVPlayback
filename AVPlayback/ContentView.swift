//
//  ContentView.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/28/25.
//

import SwiftUI
import PlaybackUI

struct ContentView: View {
    var body: some View {
        VideoPlayerFactory.makeVideoPlayer(url: URL(string: "http://23.237.104.106:8080/USA_CBS_SPORTS/index.m3u8")!)
    }
}

#Preview {
    ContentView()
}
