# Worship Song Manager - Project Summary

## Project Overview
- **Name**: Worship Song Manager
- **Platform**: iOS (SwiftUI)
- **Target Users**: Worship teams and leaders
- **Started**: April 2025
- **Developer**: Paul Lyons

## Purpose and Goals
Worship Song Manager helps worship teams store, organize, and perform songs. It replaces paper charts and binders with a digital solution that supports chords, lyrics, transposition, and setlists.

## Technical Architecture

### Core Technologies
- **UI Framework**: SwiftUI
- **Data Management**: Core Data
- **Cloud Sync**: CloudKit via NSPersistentCloudKitContainer
- **Minimum iOS Version**: iOS 17.0+
- **IDE**: Xcode 16.3

### Data Models
1. **Song**
   - Attributes: title, artist, content, key, tempo, timeSignature, copyright,
     isFavorite, dateCreated, dateModified
   - Relationships: chordCharts (to-many), setlistItems (to-many)

2. **Setlist**
   - Attributes: name, notes, dateCreated, dateModified
   - Relationships: items (to-many SetlistItem)

3. **SetlistItem**
   - Attributes: position, dateCreated, dateModified
   - Relationships: song (to-one), setlist (to-one)

### Key Views
- **SongListView**: Song library with sorting and search
- **AddSongView / EditSongView**: Form-based input for metadata and lyrics/chords
- **SongDetailView**: Read-only view for performance display
- **(Planned)**: Setlist views, markdown import, transposition tools

## Key Features
- ✅ Song creation, editing, and deletion
- ✅ CloudKit syncing of Core Data entities
- ✅ Offline support with queued sync
- ✅ Song favorite flag
- ✅ Dark mode support
- ⬜️ Setlist manager
- ⬜️ Markdown import/export
- ⬜️ Chord transposition
- ⬜️ Tagging and filtering
- ⬜️ Multi-device performance synchronization

## Technical Decisions
- Abandoned SwiftData in favor of Core Data due to macro instability
- Integrated CloudKit with schema-compliant Core Data setup
- Structured data model for future scalability and macOS support
- Added helper bindings for Core Data previews and editing

## Challenges Addressed
- SwiftData macro issues led to full Core Data migration
- Handling optional attributes and default values for CloudKit compliance
- Previews using mock objects with injected managedObjectContext

## Next Development Steps
1. Build setlist feature (create/edit, drag to reorder)
2. Add markdown file import/export
3. Implement transposition logic (chord shifting, capo mode)
4. Improve performance mode display (auto-scroll, font sizing)
5. Begin testing and performance profiling
6. Add user preferences (chord notation style, default capo)
7. Prepare app for App Store distribution (icon, screenshots)

## Resources
- [CloudKit Guide](https://developer.apple.com/documentation/cloudkit)
- [Core Data Guide](https://developer.apple.com/documentation/coredata)
- [SwiftUI](https://developer.apple.com/documentation/swiftui)

---

*Last Updated: 2025-05-14*
