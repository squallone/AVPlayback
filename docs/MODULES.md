# Module Documentation

## Overview

AVPlayback uses a modular architecture with Swift Package Manager. Each module is a focused package with a clear responsibility and explicit dependencies.

## Module Catalog

### AppFoundation

**Type**: Foundation/Utilities
**Location**: `Packages/AppFoundation/`
**Dependencies**: None

#### Purpose
Provides core utilities, extensions, and shared types used across all other modules.

#### Key Components
- **Foundation Extensions**: String, Date, Collection utilities
- **Result Builders**: Custom DSL builders
- **Common Protocols**: Identifiable, Codable extensions
- **Utility Types**: Result types, option sets
- **Error Types**: Base error protocols

#### Public API Examples
```swift
// Time formatting
public protocol TimeFormatter {
    func format(_ interval: TimeInterval) -> String
}

// Common types
public struct Identifier<T>: Hashable {
    public let value: String
}

// Utility extensions
extension String {
    public func trimmed() -> String
    public var isNotEmpty: Bool
}
```

#### Usage Guidelines
- Keep UI-agnostic (no SwiftUI or UIKit dependencies)
- Only add truly shared utilities
- Avoid domain-specific logic (that belongs in PlaybackKit)
- Prefer extensions over global functions

#### Testing
```swift
// AppFoundationTests/TimeFormatterTests.swift
final class TimeFormatterTests: XCTestCase {
    func testMinutesSecondsFormat() {
        let formatter = DefaultTimeFormatter()
        XCTAssertEqual(formatter.format(90), "1:30")
    }
}
```

---

### PlaybackKit

**Type**: Business Logic
**Location**: `Packages/PlaybackKit/`
**Dependencies**: AppFoundation

#### Purpose
Encapsulates all media playback business logic and AVFoundation integration.

#### Key Components

##### Player Abstraction
```swift
public protocol Player: AnyObject {
    var state: PlaybackState { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    
    func load(_ item: MediaItem) async throws
    func play() async throws
    func pause()
    func seek(to time: TimeInterval) async throws
}
```

##### Playback State
```swift
public enum PlaybackState: Equatable {
    case idle
    case loading
    case playing
    case paused
    case buffering
    case failed(Error)
}
```

##### Media Models
```swift
public struct MediaItem: Identifiable {
    public let id: Identifier<MediaItem>
    public let url: URL
    public let title: String
    public let duration: TimeInterval?
}
```

##### Events and Notifications
```swift
public protocol PlaybackEventHandler {
    func onStateChange(_ state: PlaybackState)
    func onTimeUpdate(_ time: TimeInterval)
    func onError(_ error: PlaybackError)
}
```

#### Internal Implementation Details
- AVPlayer management
- Audio session configuration
- Playback timing and observation
- Error handling and recovery
- Resource management

#### Usage Guidelines
- Keep UI-independent (no SwiftUI dependencies)
- Use async/await for operations
- Provide clear error messages
- Handle edge cases (network failures, invalid media, etc.)
- Make thread-safe

#### Example Usage
```swift
import PlaybackKit

let player = DefaultPlayer()

// Load and play media
let item = MediaItem(
    id: .init(value: "123"),
    url: URL(string: "https://example.com/media.mp4")!,
    title: "Sample Video"
)

try await player.load(item)
try await player.play()

// Observe state changes
player.statePublisher
    .sink { state in
        print("Player state: \(state)")
    }
```

#### Testing
```swift
// PlaybackKitTests/PlayerTests.swift
final class PlayerTests: XCTestCase {
    var player: DefaultPlayer!
    
    override func setUp() {
        super.setUp()
        player = DefaultPlayer()
    }
    
    func testLoadingMediaUpdatesState() async throws {
        let item = MockMediaItem()
        
        try await player.load(item)
        
        XCTAssertEqual(player.state, .idle)
    }
    
    func testPlayingUpdatesState() async throws {
        let item = MockMediaItem()
        try await player.load(item)
        
        try await player.play()
        
        XCTAssertEqual(player.state, .playing)
    }
}
```

---

### PlaybackUI

**Type**: User Interface
**Location**: `Packages/PlaybackUI/`
**Dependencies**: AppFoundation, PlaybackKit

#### Purpose
Provides SwiftUI views and components for media playback interfaces.

#### Key Components

##### Player View
```swift
public struct PlayerView: View {
    @ObservedObject public var viewModel: PlayerViewModel
    
    public init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            VideoDisplayView(viewModel: viewModel)
            PlayerControlsView(viewModel: viewModel)
            TimelineView(viewModel: viewModel)
        }
    }
}
```

##### View Models
```swift
@MainActor
public final class PlayerViewModel: ObservableObject {
    @Published public private(set) var state: PlaybackState
    @Published public private(set) var currentTime: TimeInterval
    @Published public private(set) var duration: TimeInterval
    
    private let player: Player
    
    public init(player: Player) {
        self.player = player
        // Setup observation...
    }
    
    public func play() {
        Task {
            try await player.play()
        }
    }
    
    public func pause() {
        player.pause()
    }
}
```

##### UI Components
- `PlayerControlsView`: Play/pause, skip buttons
- `TimelineView`: Progress slider and time displays
- `VideoDisplayView`: Video rendering surface
- `LoadingView`: Loading state indicator
- `ErrorView`: Error state display

#### Design System
```swift
// Colors
public extension Color {
    static let playerBackground = Color(.systemBackground)
    static let playerAccent = Color.accentColor
    static let playerSecondary = Color.secondary
}

// Spacing
public enum Spacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
}
```

#### Usage Guidelines
- Keep views small and focused
- Extract reusable components
- Use view models for state management
- Follow SwiftUI best practices
- Support accessibility

#### Example Usage
```swift
import SwiftUI
import PlaybackUI
import PlaybackKit

struct ContentView: View {
    @StateObject private var viewModel: PlayerViewModel
    
    init() {
        let player = DefaultPlayer()
        _viewModel = StateObject(wrappedValue: PlayerViewModel(player: player))
    }
    
    var body: some View {
        PlayerView(viewModel: viewModel)
            .onAppear {
                Task {
                    let item = MediaItem(/* ... */)
                    try await viewModel.load(item)
                }
            }
    }
}
```

#### Testing
```swift
// PlaybackUITests/PlayerViewModelTests.swift
@MainActor
final class PlayerViewModelTests: XCTestCase {
    func testPlayCallsPlayerPlay() async throws {
        let mockPlayer = MockPlayer()
        let viewModel = PlayerViewModel(player: mockPlayer)
        
        viewModel.play()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertTrue(mockPlayer.playWasCalled)
    }
}
```

---

## Adding New Modules

### When to Create a New Module
Create a new module when:
- Functionality is cohesive and self-contained
- Code would be reusable in other contexts
- Clear boundary exists with other modules
- Would improve build times (parallel compilation)

### Module Creation Checklist

#### 1. Plan the Module
- [ ] Define clear purpose and responsibility
- [ ] Identify dependencies
- [ ] Design public API
- [ ] Consider future extensibility

#### 2. Create Package Structure
```bash
cd Packages/
mkdir -p NewModuleName/Sources/NewModuleName
mkdir -p NewModuleName/Tests/NewModuleNameTests
```

#### 3. Create Package.swift
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NewModuleName",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "NewModuleName",
            targets: ["NewModuleName"]
        )
    ],
    dependencies: [
        .package(path: "../AppFoundation")
        // Add other dependencies
    ],
    targets: [
        .target(
            name: "NewModuleName",
            dependencies: ["AppFoundation"]
        ),
        .testTarget(
            name: "NewModuleNameTests",
            dependencies: ["NewModuleName"]
        )
    ]
)
```

#### 4. Add to Xcode Project
- File → Add Packages → Add Local...
- Select the new module directory
- Add to appropriate targets

#### 5. Document the Module
- [ ] Add section to this file (MODULES.md)
- [ ] Update ARCHITECTURE.md
- [ ] Create module README.md
- [ ] Update .clinerules

#### 6. Write Tests
- [ ] Create test target
- [ ] Write unit tests for public API
- [ ] Achieve reasonable coverage

### Example: Adding NetworkKit

```swift
// Packages/NetworkKit/Package.swift
let package = Package(
    name: "NetworkKit",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "NetworkKit", targets: ["NetworkKit"])
    ],
    dependencies: [
        .package(path: "../AppFoundation")
    ],
    targets: [
        .target(
            name: "NetworkKit",
            dependencies: ["AppFoundation"]
        ),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"]
        )
    ]
)
```

```swift
// Packages/NetworkKit/Sources/NetworkKit/NetworkService.swift
import Foundation
import AppFoundation

public protocol NetworkService {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

public struct Endpoint {
    public let url: URL
    public let method: HTTPMethod
    
    public init(url: URL, method: HTTPMethod = .get) {
        self.url = url
        self.method = method
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
```

## Module Maintenance

### Versioning
- Modules are versioned together with the app
- Breaking changes require careful migration
- Document breaking changes in release notes

### Deprecation Strategy
```swift
@available(*, deprecated, renamed: "newMethodName")
public func oldMethodName() { }

@available(*, deprecated, message: "Use NewType instead")
public struct OldType { }
```

### Performance Monitoring
- Profile module initialization time
- Monitor build times
- Check for unnecessary dependencies

## Best Practices

### Do's ✅
- Keep modules focused on single responsibility
- Design clear, minimal public APIs
- Document all public interfaces
- Write comprehensive tests
- Use semantic versioning for breaking changes

### Don'ts ❌
- Create circular dependencies
- Expose internal implementation details
- Skip documentation
- Ignore test coverage
- Make breaking changes without migration path

## Resources

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [Modular Architecture Guide](https://developer.apple.com/documentation/xcode/organizing-your-code-to-support-app-extensions)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
