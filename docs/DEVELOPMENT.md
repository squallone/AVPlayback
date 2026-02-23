# Development Guide

## Getting Started

### Prerequisites
- Xcode 15+ (latest stable version recommended)
- macOS 13+ or iOS 16+ deployment targets
- Swift 5.9+
- Git

### Initial Setup
1. Clone the repository
2. Open `AVPlayback.xcodeproj` in Xcode
3. Wait for Swift Package Manager to resolve dependencies
4. Build and run the project (⌘R)

### Project Structure
```
AVPlayback/
├── AVPlayback/              # Main app target
│   ├── AVPlaybackApp.swift  # App entry point
│   ├── AppRoot.swift        # Root view
│   ├── Assets.xcassets      # App assets
│   └── Info.plist          # App configuration
├── Packages/               # Local Swift packages
│   ├── AppFoundation/      # Core utilities module
│   ├── PlaybackKit/        # Playback logic module
│   └── PlaybackUI/         # UI components module
├── AVPlaybackTests/        # Integration tests
├── AVPlaybackUITests/      # UI tests
├── docs/                   # Documentation
└── .clinerules            # Claude Code configuration
```

## Development Workflow

### Before Starting Work
1. Pull latest changes from `main`
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Review `.clinerules` for project conventions
4. Check relevant documentation in `docs/`

### During Development
1. **Write Code**: Follow Swift style guidelines
2. **Test**: Write tests as you go
3. **Commit Often**: Make small, focused commits
4. **Document**: Update docs for significant changes

### Before Submitting
1. **Build**: Ensure project builds without warnings
2. **Test**: Run all tests and verify they pass
3. **Lint**: Check code style (if linter configured)
4. **Review**: Self-review your changes
5. **Update Docs**: Update documentation if needed

## Coding Standards

### Swift Style
Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

#### Naming
```swift
// Good: Clear, descriptive names
func loadMediaItem(from url: URL) async throws -> MediaItem
let playbackState: PlaybackState
var currentTime: TimeInterval

// Bad: Unclear, abbreviated names
func ld(url: URL) -> Any
let state: Int
var t: Double
```

#### Type Annotations
```swift
// Public APIs: Explicit types
public func play(item: MediaItem) -> PlaybackResult

// Internal/Private: Inference OK
private let player = AVPlayer()
```

### SwiftUI Patterns

#### View Composition
```swift
// Good: Small, focused views
struct PlayerView: View {
    var body: some View {
        VStack {
            VideoDisplay()
            PlayerControls()
            TimelineView()
        }
    }
}

// Bad: Massive view with everything
struct PlayerView: View {
    var body: some View {
        // 200 lines of UI code...
    }
}
```

#### State Management
```swift
// View-local state
@State private var isPlaying = false

// View-owned object
@StateObject private var viewModel = PlayerViewModel()

// Passed from parent
@ObservedObject var player: Player

// App-wide dependency
@EnvironmentObject var mediaLibrary: MediaLibrary
```

### Module Development

#### Public API Design
```swift
// AppFoundation/Sources/AppFoundation/TimeFormatting.swift

/// Formats time intervals for display
public protocol TimeFormatter {
    func format(_ interval: TimeInterval) -> String
}

/// Default time formatter implementation
public struct DefaultTimeFormatter: TimeFormatter {
    public init() {}
    
    public func format(_ interval: TimeInterval) -> String {
        // Implementation details (internal)
        formatMinutesSeconds(interval)
    }
}

// Keep implementation details internal
extension DefaultTimeFormatter {
    func formatMinutesSeconds(_ interval: TimeInterval) -> String {
        // Internal helper method
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
```

#### Module Dependencies
```swift
// PlaybackKit/Package.swift
let package = Package(
    name: "PlaybackKit",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "PlaybackKit", targets: ["PlaybackKit"])
    ],
    dependencies: [
        // Only depend on lower layers
        .package(path: "../AppFoundation")
    ],
    targets: [
        .target(
            name: "PlaybackKit",
            dependencies: ["AppFoundation"]
        ),
        .testTarget(
            name: "PlaybackKitTests",
            dependencies: ["PlaybackKit"]
        )
    ]
)
```

## Testing Guidelines

### Unit Tests
Test business logic in isolation:

```swift
// PlaybackKitTests/PlayerTests.swift
final class PlayerTests: XCTestCase {
    func testPlaybackStarts() async throws {
        // Arrange
        let player = Player()
        let item = MockMediaItem()
        
        // Act
        try await player.play(item)
        
        // Assert
        XCTAssertEqual(player.state, .playing)
    }
}
```

### Integration Tests
Test module interactions:

```swift
// AVPlaybackTests/PlaybackIntegrationTests.swift
final class PlaybackIntegrationTests: XCTestCase {
    func testUIUpdatesOnPlayback() async throws {
        // Test that PlaybackUI responds to PlaybackKit state changes
    }
}
```

### Test Organization
- One test class per source file being tested
- Use descriptive test names: `test<What><Condition><ExpectedResult>`
- Follow Arrange-Act-Assert pattern
- Use mock objects for dependencies

## Building and Running

### Build Configurations
- **Debug**: Development builds with assertions
- **Release**: Optimized builds for distribution

### Running Tests
```bash
# All tests
xcodebuild test -scheme AVPlayback -destination 'platform=iOS Simulator,name=iPhone 15'

# Specific test target
xcodebuild test -scheme AVPlayback -only-testing:AVPlaybackTests

# Single test
xcodebuild test -scheme AVPlayback -only-testing:AVPlaybackTests/PlayerTests/testPlaybackStarts
```

### Common Build Issues

#### Swift Package Resolution Fails
```bash
# Clear package cache
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf .build/

# Reset packages in Xcode
File → Packages → Reset Package Caches
```

#### Module Not Found
- Verify module is added to target dependencies
- Check import statements match module names
- Clean build folder (⌘⇧K)

## Git Workflow

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add video seeking functionality
fix: resolve memory leak in player cleanup
docs: update architecture documentation
refactor: extract player controls into separate view
test: add tests for playback state management
```

### Branch Naming
- `feature/description` - New features
- `fix/description` - Bug fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

### Pull Request Checklist
- [ ] Code builds without warnings
- [ ] All tests pass
- [ ] New code has tests
- [ ] Documentation updated
- [ ] No unrelated changes included
- [ ] Commit messages are clear

## Debugging Tips

### Common Issues

#### Playback Not Starting
1. Check AVAudioSession configuration
2. Verify media URL is valid
3. Check for permission issues
4. Look for player state errors

#### UI Not Updating
1. Verify `@Published` properties
2. Check `@MainActor` annotations
3. Ensure view model is observed
4. Look for SwiftUI view identity issues

### Xcode Debugging
- Breakpoints: Set breakpoints in problematic code
- LLDB: Use `po` to inspect objects
- View hierarchy: Debug View Hierarchy (⌘⇧D)
- Instruments: Profile for performance issues

## Performance Optimization

### Profiling
Use Instruments to identify bottlenecks:
- Time Profiler: CPU usage
- Allocations: Memory usage
- Leaks: Memory leaks
- System Trace: Overall system performance

### Best Practices
- Keep view body calculations simple
- Use lazy loading for heavy resources
- Profile on actual devices, not just simulator
- Watch for retain cycles in closures

## Documentation

### Code Comments
```swift
/// Brief description of what this does
///
/// More detailed explanation if needed.
///
/// - Parameter item: The media item to play
/// - Returns: Result indicating success or failure
/// - Throws: `PlaybackError` if playback cannot start
public func play(_ item: MediaItem) async throws -> PlaybackResult {
    // Implementation comments for complex logic
}
```

### Updating Documentation
When making significant changes:
1. Update relevant files in `docs/`
2. Update inline code documentation
3. Update README if needed
4. Consider adding examples

## Resources

### Internal
- [Architecture Documentation](ARCHITECTURE.md)
- [Module Documentation](MODULES.md)
- `.clinerules` - Project rules for AI assistants

### External
- [Swift.org](https://swift.org)
- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [SwiftUI by Example](https://www.hackingwithswift.com/quick-start/swiftui)
- [AVFoundation Guide](https://developer.apple.com/documentation/avfoundation)

## Getting Help

### Troubleshooting Steps
1. Check this documentation
2. Review `.clinerules` for project conventions
3. Search existing issues/discussions
4. Ask the team
5. Consult Apple documentation

### When Filing Issues
Include:
- Xcode version
- macOS/iOS version
- Steps to reproduce
- Expected vs actual behavior
- Relevant code snippets
- Console logs/error messages
