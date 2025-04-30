# Worship Song Manager - Project Summary

## Project Overview
- **Name**: Worship Song Manager
- **Platform**: iOS (SwiftUI)
- **Target Users**: Worship teams and worship leaders
- **Started**: April 2025
- **Developer**: Paul Lyons

## Purpose and Goals
The Worship Song Manager app aims to help worship teams efficiently manage their song library, create setlists, and perform songs live with features like chord/lyric display and transposition. The app[...]

## Technical Architecture

### Core Technologies
- **UI Framework**: SwiftUI
- **State Management**: MVVM pattern
- **Local Storage**: CoreData
- **Cloud Synchronization**: CloudKit (iCloud)
- **Minimum iOS Version**: iOS 17.0+

### Data Models
1. **Song**
   - Properties: id, title, artist, content, key, dateCreated, dateModified, isFavorite, tags (transformable)
   - Relationships: songInSetlists (to SongInSetlist)

2. **Setlist**
   - Properties: id, name, date, dateCreated, dateModified
   - Relationships: songInSetlists (to SongInSetlist)

3. **SongInSetlist** (join entity)
   - Properties: id, order
   - Relationships: song (to Song), setlist (to Setlist)

### View Models & Controllers
- **PersistenceController**: Manages CoreData stack and CloudKit integration
- **ContentView**: Main song list with CRUD operations
- **SongDetailView**: Displays and manages individual song information
- **AddSongView**: Interface for creating new songs
- **EditSongView**: Interface for modifying existing songs

## Key Features
1. **Song Library**: Searchable, sortable collection of worship songs
2. **Song Editor**: Interface for creating and editing songs with sections and chords
3. **Live Performance Mode**: High-contrast display optimized for performance use
4. **Chord Transposition**: Ability to transpose songs to different keys
5. **Setlist Creation**: Tool to organize songs for worship services
6. **CloudKit Sync**: Automatic synchronization across multiple devices
7. **Offline Access**: Full functionality when offline with sync when connection restored

## Implementation Status (as of 2025-04-30)
- ✅ Project setup and Core Data model designed
- ✅ CloudKit integration configured with NSPersistentCloudKitContainer
- ✅ PersistenceController implemented with sample data generation
- ✅ Basic song management (list, add, view, edit, delete) implemented
- ✅ Song favorite functionality working
- ✅ Proper value transformer setup for transformable attributes
- ⬜️ Setlist management features (in progress)
- ⬜️ Performance mode implementation pending
- ⬜️ Chord transposition pending
- ⬜️ Song tagging and filtering pending
- ⬜️ Search functionality pending
- ⬜️ UI polish and refinements pending

## Technical Decisions and Solutions
- **Entity Design**: Created three main entities (Song, Setlist, SongInSetlist) with proper relationships for efficient data management
- **Data Synchronization**: Implemented NSPersistentCloudKitContainer for automatic iCloud sync without requiring a custom backend
- **Value Transformers**: Set up custom ArrayValueTransformer extending NSSecureUnarchiveFromDataTransformer for secure tag storage
- **Preview Data**: Built sample data generation in PersistenceController for SwiftUI previews
- **MVVM Pattern**: Separating UI rendering from business logic for better testability and maintenance

## Challenges and Considerations
- Ensuring responsive performance for large song libraries
- Creating an intuitive chord editing interface
- Handling offline/online sync scenarios
- Maintaining clean architecture with proper separation of concerns
- Ensuring secure handling of transformable attributes in CoreData

## Next Development Steps
1. Implement Setlist management (SetlistListView, SetlistDetailView)
2. Add song reordering within setlists
3. Build search and filtering functionality for song library
4. Implement chord transposition feature
5. Create tag management system
6. Add TabView for better navigation between songs and setlists
7. Enhance styling for the song content display
8. Create a more polished app icon and launch screen
9. Implement unit tests for key functionality

## Resources and References
- [Apple CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [Core Data Programming Guide](https://developer.apple.com/documentation/coredata)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

---
*Last Updated: 2025-04-30*
