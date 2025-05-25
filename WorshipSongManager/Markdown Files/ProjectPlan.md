# WorshipSongManager - Comprehensive Project Plan

## 📋 Executive Summary

**Project Status:** Active Development (40% MVP Complete)  
**Architecture Assessment:** B+ (Good with room for improvement)  
**Time to MVP:** 9-11 hours remaining  
**MVVM Compliance:** 40% → Target: 100%  

WorshipSongManager is a SwiftUI iOS application designed to digitally transform worship team song management by replacing paper-based systems with a modern, CloudKit-synchronized platform.

---

## 🎯 Project Vision & Goals

### Primary Objective
Replace traditional paper binders and printed song sheets with a comprehensive digital solution that serves worship leaders, musicians, and vocalists.

### Core Value Propositions
- **Centralized Song Library:** Searchable digital collection with metadata
- **Live Performance Optimization:** Clean, readable interface for stage use
- **Team Synchronization:** CloudKit ensures consistent versions across devices
- **Offline-First Design:** Full functionality without internet dependency
- **Professional Features:** Key management, tempo tracking, setlist organization

### Target Users
1. **Worship Leaders:** Song organization, setlist creation, key/tempo management
2. **Musicians:** Chord charts, lyrics, performance information
3. **Vocalists:** Lyrics, key information, performance notes
4. **Worship Teams:** Collaborative song management and setlist coordination

---

## 🏗️ Technical Architecture

### Current Stack
- **Platform:** iOS 17.0+
- **UI Framework:** SwiftUI
- **Data Layer:** Core Data with CloudKit synchronization
- **Architecture Pattern:** MVVM (partial implementation)
- **Development Environment:** Xcode 16.3

### Data Model
```
Song (Core Entity)
├── Attributes: title, artist, key, tempo, timeSignature, content, copyright, isFavorite
├── Relationships: chordCharts (1:M), setlistItems (1:M), setlists (M:M)
└── CloudKit: Fully synchronized

Setlist (Core Entity)
├── Attributes: name, date, notes, dateCreated, dateModified
├── Relationships: songs (M:M), items (1:M SetlistItem)
└── CloudKit: Fully synchronized

SetlistItem (Join Entity)
├── Attributes: position, dateCreated, dateModified
├── Relationships: song (M:1), setlist (M:1)
└── Purpose: Ordered song positioning in setlists
```

---

## 📊 Current State Analysis

### ✅ Completed Components (40% MVP)

#### Excellent Implementation
- **Core Data + CloudKit Integration:** Robust persistence with cloud sync
- **SongDetailViewModel:** Complete MVVM implementation with validation
- **SongListViewModel:** Proper filtering, search, and fetch logic
- **Persistence Layer:** Well-structured controllers with preview support

#### Good Implementation
- **SongDetailView:** Clean UI with proper ViewModel integration
- **SongListView:** Functional list with search and navigation
- **Data Model:** Well-designed Core Data schema

### ⚠️ Components Needing Refactoring

#### Critical Issues
- **AddSongView & EditSongView:** 90% code duplication, direct Core Data access
- **SetlistListView:** Direct Core Data manipulation, missing ViewModel
- **SetlistDetailView:** Basic implementation without proper state management
- **SongPickerView:** Functional but lacks ViewModel architecture

#### Technical Debt
- **SongFormView:** Complex direct bindings, potential memory issues
- **ValueTransformerRegistration:** Marked for deprecation, unused
- **Mixed Architectural Patterns:** Inconsistent MVVM implementation

---

## 🚀 Refactoring Roadmap to 100% MVVM Compliance

### Phase 1: Foundation Cleanup (2-3 hours)
**Priority:** 🔴 Critical

#### Immediate Actions
1. **Remove Deprecated Code**
   - Delete `ValueTransformerRegistration.swift`
   - Clean up unused `SongFormView.swift` if applicable
   - Remove commented/obsolete code sections

2. **Create Base ViewModel Protocol**
   ```swift
   protocol BaseViewModel: ObservableObject {
       var isLoading: Bool { get set }
       var errorMessage: String? { get set }
       func handleError(_ error: Error)
   }
   ```

3. **Implement Error Handling Service**
   ```swift
   @MainActor
   final class ErrorHandlingService: ObservableObject {
       @Published var currentError: AppError?
       @Published var validationErrors: [ValidationError] = []
   }
   ```

### Phase 2: Song Management Consolidation (3-4 hours)
**Priority:** 🔴 Critical

#### Unified Song Form Implementation
1. **Create SongFormViewModel**
   ```swift
   @MainActor
   final class SongFormViewModel: ObservableObject {
       enum Mode { case add, edit(Song) }
       
       // State Management
       @Published var title: String = ""
       @Published var artist: String = ""
       @Published var key: String = ""
       @Published var tempo: String = ""
       @Published var timeSignature: String = "4/4"
       @Published var copyright: String = ""
       @Published var content: String = ""
       @Published var isFavorite: Bool = false
       
       // UI State
       @Published var isLoading: Bool = false
       @Published var validationErrors: [ValidationError] = []
       
       // Methods
       func save() async -> Bool
       func validate() -> [ValidationError]
       func cancel()
   }
   ```

2. **Replace Duplicate Views**
   - Create unified `SongFormView` using `SongFormViewModel`
   - Remove `AddSongView` and `EditSongView`
   - Update navigation to use new unified view

3. **Implement Comprehensive Validation**
   - Required field validation
   - Tempo numeric validation
   - Content length validation
   - Duplicate title checking

### Phase 3: Setlist Management Refactoring (3-4 hours)
**Priority:** 🟡 High

#### SetlistListViewModel Implementation
```swift
@MainActor
final class SetlistListViewModel: ObservableObject {
    @Published var setlists: [Setlist] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var showingAddSheet: Bool = false
    
    func fetchSetlists() async
    func deleteSetlists(at offsets: IndexSet) async
    func createNewSetlist() async
}
```

#### SetlistDetailViewModel Implementation
```swift
@MainActor
final class SetlistDetailViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var isEditing: Bool = false
    @Published var showingSongPicker: Bool = false
    
    func reorderSongs(from source: IndexSet, to destination: Int)
    func removeSongs(at offsets: IndexSet)
    func addSongs(_ songs: [Song])
}
```

#### SongPickerViewModel Implementation
```swift
@MainActor
final class SongPickerViewModel: ObservableObject {
    @Published var availableSongs: [Song] = []
    @Published var selectedSongs: Set<Song> = []
    @Published var searchText: String = ""
    
    func fetchAvailableSongs() async
    func toggleSelection(_ song: Song)
    func saveSelections() async -> Bool
}
```

### Phase 4: Architecture Enhancement (2-3 hours)
**Priority:** 🟢 Medium

#### Navigation Coordination
```swift
@MainActor
final class AppCoordinator: ObservableObject {
    enum Route {
        case songList, songDetail(Song), songForm(SongFormViewModel.Mode)
        case setlistList, setlistDetail(Setlist)
    }
    
    @Published var navigationPath: [Route] = []
    
    func navigate(to route: Route)
    func goBack()
    func resetToRoot()
}
```

#### Service Layer Implementation
```swift
@MainActor
final class CoreDataService: ObservableObject {
    private let context: NSManagedObjectContext
    
    // Generic CRUD operations
    func save() async throws
    func delete<T: NSManagedObject>(_ object: T) async throws
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T]
}
```

---

## 🧪 Testing Strategy

### Unit Testing Plan
```swift
// ViewModel Testing Structure
SongFormViewModelTests
├── testValidationWithEmptyTitle()
├── testSaveOperationSuccess()
├── testSaveOperationFailure()
├── testCancelChanges()
└── testModeTransitions()

SongListViewModelTests
├── testFetchSongs()
├── testSearchFiltering()
├── testDeleteOperation()
└── testErrorHandling()

SetlistViewModelTests
├── testSetlistCreation()
├── testSongReordering()
├── testSongAddition()
└── testValidation()
```

### UI Testing Priorities
1. **Critical User Flows**
   - Song creation and editing
   - Setlist management
   - Search and filtering

2. **Error Scenarios**
   - Network connectivity issues
   - CloudKit sync conflicts
   - Invalid input handling

---

## 📱 Feature Roadmap

### MVP Features (Remaining: 9-11 hours)
- [x] Song CRUD operations
- [x] Basic setlist functionality
- [ ] Complete MVVM refactoring
- [ ] Comprehensive error handling
- [ ] Loading states and user feedback
- [ ] Input validation and constraints

### Post-MVP Features (Phase 2)
- [ ] **Markdown Import/Export** (Est: 3-4 hours)
  - ChordPro format support
  - Plain text import
  - Batch import functionality
  
- [ ] **Key Transposition** (Est: 4-5 hours)
  - Chord recognition and parsing
  - Key shifting algorithms
  - Capo mode implementation
  
- [ ] **Performance Mode** (Est: 2-3 hours)
  - Auto-scroll functionality
  - Customizable font sizes
  - Presentation-optimized layout

### Advanced Features (Phase 3)
- [ ] **Multi-device Synchronization** (Est: 6-8 hours)
  - Real-time setlist sharing
  - Leader/follower device modes
  - Performance state synchronization

- [ ] **Advanced Organization** (Est: 3-4 hours)
  - Tag-based categorization
  - Advanced filtering options
  - Custom song metadata fields

- [ ] **macOS Support** (Est: 8-10 hours)
  - Mac Catalyst implementation
  - macOS-specific UI adaptations
  - Desktop performance optimizations

---

## ⚡ Performance Optimization Plan

### Current Performance Issues
1. **Inefficient Fetching:** `SongListViewModel` fetches on every `onAppear`
2. **Memory Management:** Direct Core Data bindings in forms
3. **Large Dataset Handling:** No pagination for extensive song libraries

### Optimization Strategy
1. **Implement Pagination**
   ```swift
   // Batch loading for large song libraries
   func fetchNextBatch() async
   ```

2. **Optimize Core Data Queries**
   ```swift
   // Use NSFetchRequest with proper predicates and sort descriptors
   // Implement result caching where appropriate
   ```

3. **Memory Management**
   ```swift
   // Replace direct bindings with ViewModel-mediated state
   // Implement proper cleanup in ViewModels
   ```

---

## 🚨 Risk Management

### Technical Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| CloudKit Sync Conflicts | High | Medium | Implement robust conflict resolution |
| Performance with Large Libraries | Medium | High | Implement pagination and lazy loading |
| Breaking Changes During Refactor | High | Low | Incremental refactoring with feature flags |

### Project Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Scope Creep | Medium | High | Strict MVP feature prioritization |
| Timeline Slippage | Medium | Medium | Regular progress reviews and adjustments |
| Technical Debt Accumulation | High | Medium | Mandatory code review and refactoring phases |

---

## 📏 Success Metrics

### Development Metrics
- **MVVM Compliance:** Current 40% → Target 100%
- **Code Coverage:** Target 80%+ for ViewModels
- **Code Duplication:** Reduce by 70%
- **Build Time:** Maintain under 30 seconds

### User Experience Metrics
- **App Launch Time:** < 2 seconds
- **Search Response Time:** < 500ms
- **CloudKit Sync Time:** < 10 seconds for typical library
- **Crash Rate:** < 0.1%

### Feature Completeness
- **MVP Features:** 100% complete
- **Error Handling:** Comprehensive user feedback
- **Offline Functionality:** 100% feature parity
- **Performance:** Smooth 60fps scrolling

---

## 🛠️ Development Guidelines

### Code Standards
- **SwiftUI Best Practices:** Use native components and patterns
- **MVVM Compliance:** All views must use ViewModels
- **Error Handling:** Never use `try?` without user feedback
- **Documentation:** All public methods must have documentation comments

### Git Workflow
- **Feature Branches:** One branch per major refactoring phase
- **Commit Messages:** Conventional commit format
- **Code Review:** All changes require review before merge
- **Release Tags:** Semantic versioning for releases

### File Organization
```
WorshipSongManager/
├── App/
│   └── WorshipSongManagerApp.swift
├── Models/
│   ├── CoreData/
│   └── Extensions/
├── ViewModels/
│   ├── Song/
│   ├── Setlist/
│   └── Shared/
├── Views/
│   ├── Song/
│   ├── Setlist/
│   └── Shared/
├── Services/
│   ├── CoreDataService.swift
│   ├── PersistenceController.swift
│   └── ErrorHandlingService.swift
└── Utilities/
    ├── Extensions/
    └── Constants/
```

---

## 📅 Implementation Timeline

### Week 1: Foundation & Critical Refactoring
- **Days 1-2:** Phase 1 (Foundation Cleanup)
- **Days 3-5:** Phase 2 (Song Management Consolidation)

### Week 2: Architecture & Enhancement
- **Days 1-3:** Phase 3 (Setlist Management Refactoring)
- **Days 4-5:** Phase 4 (Architecture Enhancement)

### Week 3: Testing & Polish
- **Days 1-2:** Unit test implementation
- **Days 3-4:** UI testing and bug fixes
- **Day 5:** Documentation and release preparation

---

## 📞 Support & Resources

### Development Resources
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)

### Community Resources
- Swift Forums
- iOS Developer Slack
- Stack Overflow (ios, swiftui, core-data tags)

---

*Last Updated: May 24, 2025*  
*Document Version: 1.0*  
*Project Phase: Active Development*