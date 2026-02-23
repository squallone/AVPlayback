# AVPlayback Architecture

## Overview

AVPlayback is a modular Swift application for audio/video playback, built using SwiftUI and modern Swift concurrency patterns. The application follows a layered, modular architecture to promote code reusability, testability, and maintainability.

## Architecture Principles

### Modular Design
The codebase is organized into focused Swift Package Manager modules, each with a single responsibility. This approach provides:
- **Isolation**: Modules can be developed and tested independently
- **Reusability**: Modules can be used in different contexts (app, extensions, CLI tools)
- **Clear boundaries**: Explicit dependencies between modules
- **Scalability**: Easy to add new modules as features grow

### Layered Architecture
```
┌─────────────────────────────────┐
│       App Layer                 │
│  (AVPlaybackApp, AppRoot)       │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│       UI Layer                  │
│      (PlaybackUI)               │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│    Business Logic Layer         │
│      (PlaybackKit)              │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│     Foundation Layer            │
│     (AppFoundation)             │
└─────────────────────────────────┘
```

### Dependency Flow
Dependencies flow in one direction:
- **Top → Down**: Upper layers depend on lower layers
- **Never Up**: Lower layers never depend on upper layers
- **No Cycles**: Circular dependencies are prohibited

## Module Overview

### AppFoundation
**Purpose**: Core utilities and shared infrastructure

**Responsibilities**:
- Common types and protocols
- Foundation extensions
- Utility functions
- Shared constants
- Error types

**Dependencies**: None (pure foundation)

**Example Use Cases**:
- Date/time utilities
- String extensions
- Result builders
- Shared protocols

### PlaybackKit
**Purpose**: Business logic for media playback

**Responsibilities**:
- AVFoundation integration
- Playback state management
- Media handling and processing
- Audio session management
- Playback controls logic

**Dependencies**: AppFoundation

**Key Components**:
- Player abstraction
- Playback state machine
- Media item models
- Playback events

**Example Use Cases**:
- Playing/pausing media
- Seeking to time positions
- Handling playback errors
- Managing audio session

### PlaybackUI
**Purpose**: User interface for playback

**Responsibilities**:
- SwiftUI views for playback interface
- View models for UI state
- Player controls (play, pause, seek)
- Visual feedback components

**Dependencies**: AppFoundation, PlaybackKit

**Key Components**:
- Player view
- Control buttons
- Progress slider
- Time displays

## Design Patterns

### MVVM (Model-View-ViewModel)
- **Models**: Defined in PlaybackKit
- **Views**: SwiftUI views in PlaybackUI
- **ViewModels**: Observable objects managing view state

### Dependency Injection
- Dependencies passed through initializers
- Avoids global state and singletons
- Improves testability

### Protocol-Oriented Design
- Modules expose protocol-based APIs
- Implementation details remain internal
- Easy to mock for testing

### Swift Concurrency
- `async/await` for asynchronous operations
- `@MainActor` for UI updates
- Structured concurrency with tasks

## Data Flow

### Unidirectional Data Flow
```
User Action → View → ViewModel → PlaybackKit → AVFoundation
                ↑                      ↓
                └──────── State ───────┘
```

1. User interacts with UI (PlaybackUI)
2. View triggers ViewModel method
3. ViewModel calls PlaybackKit business logic
4. PlaybackKit updates state and notifies observers
5. ViewModel updates published properties
6. View automatically re-renders

## Communication Patterns

### Between Layers
- **Protocols**: Define contracts between modules
- **Closures/Callbacks**: For completion handlers
- **Async/Await**: For asynchronous operations
- **Combine Publishers**: For reactive streams (when appropriate)

### State Management
- `@State` for local view state
- `@StateObject` for view-owned observable objects
- `@ObservedObject` for passed observable objects
- `@EnvironmentObject` for app-wide dependencies

## Testing Strategy

### Unit Tests
- Test each module independently
- Mock dependencies from other modules
- Focus on business logic in PlaybackKit

### Integration Tests
- Test module interactions
- Verify data flow between layers
- Test in main app target

### UI Tests
- Test critical user flows
- Verify UI responds to state changes
- Keep tests maintainable

## Future Expansion

### Potential New Modules
As features grow, consider adding:
- **NetworkKit**: Remote media streaming
- **StorageKit**: Local media storage and caching
- **MediaLibrary**: Media catalog and organization
- **AnalyticsKit**: Usage tracking
- **SettingsKit**: User preferences
- **ExportKit**: Media export functionality

### Module Addition Guidelines
When adding new modules:
1. Define clear responsibility
2. Identify dependencies
3. Design public API first
4. Keep implementation internal
5. Add comprehensive tests
6. Document in this file

## Performance Considerations

### Module Loading
- Keep module initialization lightweight
- Lazy-load heavy resources
- Minimize startup dependencies

### Memory Management
- Use value types where possible
- Be mindful of reference cycles in closures
- Profile with Instruments

### Playback Performance
- Optimize AVFoundation usage
- Minimize main thread blocking
- Handle background playback efficiently

## Best Practices

### Do's
✅ Keep modules focused and cohesive
✅ Design clear public APIs
✅ Write documentation for public interfaces
✅ Test modules independently
✅ Use dependency injection
✅ Follow Swift API design guidelines

### Don'ts
❌ Create circular dependencies
❌ Leak implementation details in public APIs
❌ Use global state or singletons unnecessarily
❌ Skip testing for "simple" code
❌ Ignore memory management
❌ Make assumptions about module clients

## References

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [AVFoundation Programming Guide](https://developer.apple.com/documentation/avfoundation)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
