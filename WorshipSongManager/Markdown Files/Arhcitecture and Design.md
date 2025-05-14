# Architecture and Design

## Overview

**Platform:** iOS 17.0 app using SwiftUI and Core Data with CloudKit sync, built in Xcode 16.3.

### Core Components:
- **Model:** Core Data for local storage (songs, setlists); CloudKit for syncing across devices.
- **View:** SwiftUI with light/dark mode, optimized for legibility and minimal distraction.
- **Logic Layer:** Direct use of model context and NSManagedObject bindings; ViewModels may be introduced for advanced business logic.

### Storage: 
- Local Core Data for offline access.
- CloudKit-backed NSPersistentCloudKitContainer for sync.
- Planned: file-based import/export (plain text, ChordPro).

### Data Flow: 
- Offline edits → Core Data → CloudKit sync when online.
- Import → Parse text/ChordPro → Core Data.

### Future-Ready: 
- Modular architecture to introduce ViewModels, feature toggles, and expand across platforms (macOS).

## Core Components and Relationships

### Entities:
- **Song:** Stores metadata (title, artist, key, tempo), lyrics, chords, and flags (e.g., favorite).
- **Setlist:** Collection of songs in ordered sequence with optional notes.
- **SetlistItem:** Join entity representing a song within a setlist and its position.

### Sync:
- CloudKit mirrors Core Data entities.
- Conflict resolution based on last-modified timestamp strategy.

### View Hierarchy:
- **SongListView:** List of songs, with sort and search features.
- **AddSongView / EditSongView:** Input interfaces for metadata and lyrics/chords.
- **SongDetailView:** Read-only presentation of a selected song.
- **Setlist Views (planned):** Management and ordering of songs for live services.

## User Experience Flows

- **Adding a Song:** Tap "+" → Fill in song metadata and lyrics/chords → Save (offline or queued for sync).
- **Viewing Details:** Tap a song to view content and metadata.
- **Editing:** Modify any existing song → Save updates locally and sync automatically.
- **Importing:** (Planned) Select text/ChordPro file → Preview → Save to library.
- **Syncing:** Transparent to user; background sync when online.

---

*Last Updated: 2025-05-14*
