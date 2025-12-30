//
//  File.swift
//  PlaybackUI
//
//  Created by Abdiel Soto on 12/29/25.
//

import AVFoundation
import Foundation
import SwiftUI

#if os(macOS)
import AppKit
public typealias NativeView = NSView
public typealias NativeViewRepresentable = NSViewRepresentable
#else
import UIKit
public typealias NativeView = UIView
public typealias NativeViewRepresentable = UIViewRepresentable
#endif
