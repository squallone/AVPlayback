//
//  ContentView.swift
//  AVPlayback
//
//  Created by Abdiel Soto on 12/28/25.
//

import SwiftUI
import PlaybackUI

struct AppRoot: View {
    var body: some View {
        NavigationStack {
            PlaybackMediaListView()
        }
    }
}

#Preview {
    AppRoot()
}
