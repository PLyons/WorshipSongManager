# Worship Song Manager - Project Summary

## Project Overview
- **Name**: Worship Song Manager
- **Platform**: iOS (SwiftUI)
- **Target Users**: Worship teams and worship leaders
- **Started**: April 2025
- **Developer**: Paul Lyons

## Purpose and Goals
The Worship Song Manager app aims to help worship teams efficiently manage their song library, create setlists, and perform songs live with features like chord/lyric display and transposition. The app replaces traditional paper binders and provides real-time synchronization across team members' devices.

## Technical Architecture

### Core Technologies
- **UI Framework**: SwiftUI
- **State Management**: MVVM pattern
- **Local Storage**: CoreData
- **Cloud Synchronization**: CloudKit (iCloud)
- **Minimum iOS Version**: iOS 17.0+

### Data Models
1. **Song**: Core entity representing a worship song
   - Properties: id, title, artist, key
   - Relationships: songSections, setlistItems

2. **SongSection**: Parts of a song (verse, chorus, bridge, etc.)
   - Properties: id, type, order
   - Relationships: song, lines

3. **LyricLine**: Individual lines of lyrics within a section
   - Properties: id, text, order
   - Relationships: section, chords

4. **ChordAnnotation**: Chord symbols placed at specific positions in lyrics
   - Properties: id, chordSymbol, position
   - Relationships: line

5. **Setlist**: Ordered collection of songs for a service
   - Properties: id, title, created, modified
   - Relationships: items

6. **SetlistItem**: Junction entity for songs in a setlist
   - Properties: id, order
   - Relationships: setlist, song

### View Models
- **SongLibraryViewModel**: Manages song listing and filtering
- **SongDetailViewModel**: Handles song editing and chord transposition
- **SetlistViewModel**: Manages setlists and song ordering
- **PerformanceViewModel**: Controls performance mode display

## Key Features
1. **Song Library**: Searchable, sortable collection of worship songs
2. **Song Editor**: Interface for creating and editing songs with sections and chords
3. **Live Performance Mode**: High-contrast display optimized for performance use
4. **Chord Transposition**: Ability to transpose songs to different keys
5. **Setlist Creation**: Tool to organize songs for worship services
6. **CloudKit Sync**: Automatic synchronization across multiple devices
7. **Offline Access**: Full functionality when offline with sync when connection restored

## Implementation Status (as of 2025-04-29)
- ✅ Project setup and Core Data model designed
- ✅ CloudKit integration configured
- ✅ Renamed Core Data entity "Section" to "SongSection" to avoid naming conflicts
- ⬜️ Basic UI structure (ContentView, TabView)
- ⬜️ Song library listing and search functionality
- ⬜️ Song detail view in progress
- ⬜️ Chord editing interface in progress
- ⬜️ Performance mode implementation pending
- ⬜️ Setlist management features pending
- ⬜️ Settings and preferences pending

## Technical Decisions and Solutions
- **Entity Renaming**: Resolved naming conflict between Core Data "Section" entity and SwiftUI's built-in Section view by renaming to "SongSection"
- **Data Synchronization**: Selected NSPersistentCloudKitContainer for automatic iCloud sync without requiring a custom backend
- **Chord Representation**: Storing chord symbols with position indices rather than embedding in text for easier transposition
- **MVVM Pattern**: Separating UI rendering from business logic for better testability and maintenance

## Challenges and Considerations
- Ensuring responsive performance for large song libraries
- Creating an intuitive chord editing interface
- Handling offline/online sync scenarios
- Maintaining clean architecture with proper separation of concerns

## Next Development Steps
1. Basic UI structure
2. Song library listing and search functionality
3. Song detail view for section and chord editing
4. Chord editing interface
5. Implement PerformanceView with optimized display
6. Create SetlistView for managing worship service song order
7. Add settings for appearance customization
8. Implement unit tests for key functionality
9. Develop chord chart rendering algorithm

## Resources and References
- [Apple CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [Core Data Programming Guide](https://developer.apple.com/documentation/coredata)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

---
*Last Updated: 2025-04-29*
