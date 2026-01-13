//
//  SwiftUIView.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/12/26.
//

import SwiftUI
import AVKit

struct AirPlayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let picker = AVRoutePickerView()
        picker.activeTintColor = .white
        picker.tintColor = .white
        picker.backgroundColor = .clear
        return picker
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    AirPlayButton()
}
