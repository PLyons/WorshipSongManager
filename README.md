# WorshipSongManager

**A modern iOS application for worship teams to manage songs, create setlists, and enhance live worship experiences.**

[![Platform](https://img.shields.io/badge/platform-iOS%2017.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![Core Data](https://img.shields.io/badge/Data-Core%20Data%20%2B%20CloudKit-green.svg)](https://developer.apple.com/documentation/coredata)

---

## 🎵 Overview

WorshipSongManager transforms the way worship teams organize and perform music by replacing traditional paper binders with a comprehensive digital solution. Built for worship leaders, musicians, and vocalists, this app provides seamless song management with CloudKit synchronization across all team devices.

### ✨ Key Features

**Current Features:**
- 📚 **Comprehensive Song Library** - Store lyrics, chords, keys, tempo, and metadata
- 📋 **Setlist Management** - Create and organize songs for worship services
- 🔍 **Smart Search** - Quickly find songs by title, artist, or content
- ⭐ **Favorites System** - Mark frequently used songs for quick access
- ☁️ **CloudKit Sync** - Automatic synchronization across all team devices
- 📱 **Offline Ready** - Full functionality without internet connection
- 🌙 **Dark Mode Support** - Optimized for both light and dark environments

**Coming Soon:**
- 🎼 **Key Transposition** - Automatically adjust songs to different keys
- 📄 **Import/Export** - Support for ChordPro and plain text formats
- 🎯 **Performance Mode** - Optimized display for live worship
- 🔄 **Real-time Sync** - Live collaboration between team devices

---

## 🎯 Who It's For

### Worship Leaders
- Organize comprehensive song libraries with detailed metadata
- Create and manage setlists for various services and events
- Share consistent song versions with entire worship team
- Access songs quickly during live worship sessions

### Musicians & Vocalists
- View chord charts and lyrics in performance-optimized format
- Access songs in appropriate keys and tempos
- Follow along with setlists during services
- Work confidently with offline access and automatic sync

### Worship Teams
- Collaborate on song arrangements and setlist creation
- Maintain synchronized libraries across all team member devices
- Replace scattered paper systems with unified digital platform
- Professional features without complex learning curves

---

## 🏗️ Technical Architecture

### Built With
- **SwiftUI** - Modern, declarative UI framework
- **Core Data** - Robust local data persistence
- **CloudKit** - Seamless cloud synchronization
- **MVVM Architecture (Approx. 95% Implemented)** - Clean, testable, maintainable code
- **iOS 17.0+** - Latest iOS features and optimizations

### Data Model
```
Song
├── Title, Artist, Key, Tempo, Time Signature
├── Lyrics/Chord Content
├── Copyright Information
├── Favorite Status
└── Creation/Modification Dates

Setlist
├── Name, Date, Notes
├── Associated Songs (Many-to-Many)
├── Song Ordering via SetlistItem
└── Creation/Modification Dates
```

### Key Technical Features
- **Offline-First Design** - Full functionality without internet
- **CloudKit Integration** - Automatic background synchronization  
- **Conflict Resolution** - Smart handling of concurrent edits
- **Performance Optimized** - Smooth scrolling with large song libraries
- **Memory Efficient** - Optimized for extended live performance use

---

## 🚀 Getting Started

### Prerequisites
- iOS 17.0 or later
- Xcode 16.3 or later
- Apple Developer Account (for CloudKit features)

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/PLyons/WorshipSongManager.git
   cd WorshipSongManager
   ```

2. **Open in Xcode**
   ```bash
   open WorshipSongManager.xcodeproj
   ```

3. **Configure CloudKit**
   - Enable CloudKit capability in project settings
   - Configure CloudKit container in Apple Developer Console
   - Update container identifier in project settings

4. **Build and Run**
   - Select your target device or simulator
   - Build and run the project (⌘+R)

### First Launch
1. The app will create a local Core Data store on first launch
2. Add your first song using the "+" button
3. Create a setlist and add songs to organize your worship sets
4. CloudKit sync will begin automatically when signed into iCloud

---

## 📱 App Structure & Navigation

### Main Sections

#### Song Library
- **Song List View** - Browse all songs with search and filtering
- **Song Detail View** - View complete song information optimized for performance
- **Add/Edit Song (SongFormView)** - Comprehensive unified form for song metadata and content
- **Favorites** - Quick access to frequently used songs

#### Setlist Management
- **Setlist List** - View all created setlists sorted by date
- **Setlist Detail** - Manage songs within a specific setlist
- **Song Picker** - Add songs to setlists with visual selection
- **Reordering** - Drag and drop to arrange song order

### Data Flow
```
User Input → ViewModel → Core Data → CloudKit Sync
     ↑                                      ↓
UI Updates ← ViewModel ← Core Data ← Background Sync
```

---

## 🛠️ Development

### Project Structure
```
WorshipSongManager/
├── App/
│   └── WorshipSongManagerApp.swift          # App entry point
├── Models/
│   ├── WorshipSongManager.xcdatamodeld     # Core Data model
│   └── Extensions/                          # Entity extensions
├── ViewModels/
│   ├── Song/                               # Song-related ViewModels
│   │   ├── SongListViewModel.swift
│   │   ├── SongDetailViewModel.swift
│   │   └── SongFormViewModel.swift
│   └── Setlist/                            # Setlist-related ViewModels
│       ├── SetlistListViewModel.swift
│       └── SetlistDetailViewModel.swift
│       └── SongPickerViewModel.swift (Pending finalization)
├── Views/
│   ├── Song/                               # Song management views
│   │   ├── SongListView.swift
│   │   ├── SongDetailView.swift
│   │   └── SongFormView.swift              # Unified view for Add/Edit Song
│   └── Setlist/                            # Setlist management views
│       ├── SetlistListView.swift
│       ├── SetlistDetailView.swift
│       └── SongPickerView.swift
└── Services/
    ├── PersistenceController.swift          # Core Data stack
    └── PreviewPersistenceController.swift   # Preview support
```

### Architecture Patterns

#### MVVM Implementation
```swift
// Example ViewModel Structure
@MainActor
final class SongListViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    func fetchSongs() async { /* Implementation */ }
    func deleteSongs(at offsets: IndexSet) async { /* Implementation */ }
}
```

#### Core Data + CloudKit
```swift
// Persistence Controller with CloudKit
let container = NSPersistentCloudKitContainer(name: "WorshipSongManager")
container.persistentStoreDescriptions.first?.setOption(true as NSNumber, 
    forKey: NSPersistentHistoryTrackingKey)
```

### Development Guidelines

#### Code Standards
- **SwiftUI Best Practices** - Use native components and declarative patterns
- **MVVM Compliance** - All views should use ViewModels for business logic
- **Error Handling** - Comprehensive error handling with user feedback
- **Documentation** - All public methods must include documentation comments
- **Testing** - Unit tests for ViewModels, UI tests for critical user flows

#### Git Workflow
- **Feature Branches** - Create branches for new features or major refactoring
- **Conventional Commits** - Use standardized commit message format
- **Code Review** - All changes require review before merging to main
- **Semantic Versioning** - Version releases following semantic versioning

---

## 📋 Roadmap

### Current Status: MVP Development
**Progress: ~90% Complete**

### Phase 1: MVP Completion (Current Focus)
- [x] Core song CRUD operations
- [x] Setlist functionality (List & Detail views refactored to MVVM, Song Picking pending final MVVM)
- [x] CloudKit synchronization
- [🔄] Complete MVVM refactoring (SongPickerView pending finalization)
- [✅] Comprehensive error handling (Enhanced in Phases 1 & 2, ongoing refinement)
- [✅] Loading states and user feedback (Enhanced in Phases 1 & 2, ongoing refinement)

### Phase 2: Enhanced Features
- [ ] **Key Transposition** - Chord recognition and key shifting
- [ ] **Import/Export** - ChordPro and plain text file support
- [ ] **Performance Mode** - Auto-scroll and presentation optimization
- [ ] **Advanced Search** - Tags, filters, and categorization

### Phase 3: Advanced Collaboration
- [ ] **Real-time Sync** - Live collaboration between devices
- [ ] **Presentation Integration** - Display lyrics/chords on external screens
- [ ] **Role-based Access** - Different views for leaders vs. musicians
- [ ] **macOS Support** - Desktop companion application

---

## 🧪 Testing

### Testing Strategy
- **Unit Tests** - ViewModel logic and data operations
- **Integration Tests** - Core Data and CloudKit functionality  
- **UI Tests** - Critical user workflows and navigation
- **Performance Tests** - Large dataset handling and memory usage

### Running Tests
```bash
# Run all tests
xcodebuild test -scheme WorshipSongManager -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test suite
xcodebuild test -scheme WorshipSongManager -only-testing:WorshipSongManagerTests/SongViewModelTests
```

---

## 🤝 Contributing

We welcome contributions from the worship and developer communities! Here's how you can help:

### Ways to Contribute
1. **Bug Reports** - Report issues via GitHub Issues
2. **Feature Requests** - Suggest new features or improvements
3. **Code Contributions** - Submit pull requests for bug fixes or features
4. **Documentation** - Help improve documentation and examples
5. **Testing** - Help test new features and provide feedback

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following our coding guidelines
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code of Conduct
- Be respectful and inclusive
- Focus on constructive feedback
- Help newcomers learn and contribute
- Maintain professional communication

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Acknowledgments
- Apple's Core Data and CloudKit frameworks
- SwiftUI framework and documentation
- iOS developer community resources and examples

---

## 📞 Support & Resources

### Getting Help
- **GitHub Issues** - Bug reports and feature requests
- **Discussions** - General questions and community support
- **Documentation** - Comprehensive guides in `/Markdown Files` folder
- **Wiki** - Additional resources and tutorials

### Development Resources
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [Project Documentation](/Markdown Files)

### Community
- **Worship Technology Forums** - Discussion about worship tech solutions
- **iOS Developer Community** - General iOS development support
- **SwiftUI Communities** - SwiftUI-specific questions and examples

---

## 📊 Project Status

### Statistics
- **Platform:** iOS 17.0+
- **Language:** Swift 5.9
- **Architecture:** MVVM (Approx. 95% Implemented) with SwiftUI
- **Data:** Core Data + CloudKit
- **Development Status:** Active Development
- **License:** MIT

### Recent Updates
- ✅ Core Data model finalized with CloudKit sync
- ✅ Song and Setlist (List/Detail) CRUD operations largely MVVM compliant
- ✅ MVVM pattern established for core views and most setlist views
- ✅ Comprehensive project documentation (ProjectPlan.md)
- 🔄 Finalizing MVVM refactoring (SongPickerView pending); Setlist views (List & Detail) now MVVM compliant.
- 📋 Planning advanced features for Phase 2 (Post-MVP)

---

**Transform your worship team's music management today with WorshipSongManager.**

*Built with ❤️ for the worship community*

---

*Last Updated: May 28, 2025*  
*Version: 1.0.0-beta.2*  
*Developed by Paul Lyons*
