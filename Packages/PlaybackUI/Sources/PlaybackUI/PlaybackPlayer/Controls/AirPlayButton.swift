//
//  SwiftUIView.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 1/12/26.
//


import SwiftUI
import AVKit

struct AirPlayButton: NativeViewRepresentable {
    
    // Customize color to match your player UI
    var tintColor: Color = .white
    
    // MARK: - macOS
    #if os(macOS)
    typealias NSViewType = AVRoutePickerView

    func makeNSView(context: Context) -> AVRoutePickerView {
        let picker = AVRoutePickerView()
        picker.setRoutePickerButtonColor(NSColor(tintColor), for: .normal)
        picker.isRoutePickerButtonBordered = false
        return picker
    }
    
    func updateNSView(_ nsView: AVRoutePickerView, context: Context) {
        nsView.setRoutePickerButtonColor(NSColor(tintColor), for: .normal)
    }
    #endif

    // MARK: - iOS / tvOS
    #if os(iOS) || os(tvOS)
    typealias UIViewType = AVRoutePickerView

    func makeUIView(context: Context) -> AVRoutePickerView {
        let picker = AVRoutePickerView()
        // Determine if we are picking video (Apple TV) or just audio
        picker.prioritizesVideoDevices = true
        picker.activeTintColor = UIColor(tintColor)
        picker.tintColor = UIColor(tintColor)
        return picker
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        uiView.tintColor = UIColor(tintColor)
        uiView.activeTintColor = UIColor(tintColor)
    }
    #endif
}

#Preview {
    AirPlayButton()
}

