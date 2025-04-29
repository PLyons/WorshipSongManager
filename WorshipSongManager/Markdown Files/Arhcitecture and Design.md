# Architecture and Design

## Overview

**Platform:** iOS 17.0 app using SwiftUI and CoreData, built in Xcode 16.3.

### Core Components:
- **Model:** CoreData for local storage (songs, setlists); CloudKit for sync.
- **View:** SwiftUI with light/dark mode, optimized for readability.
- **Controller:** ViewModels for business logic (e.g., transposition, parsing ChordPro).

### Storage: 
- Local CoreData for offline access.
- CloudKit for syncing songs across devices.
- File-based import/export (plain text, ChordPro).

### Data Flow: 
- Offline edits → CoreData → CloudKit sync when online.
- Import → Parse text/ChordPro → CoreData.

### Future-Ready: 
- Modular design with protocols for storage/sync layers.

## Core Components and Relationships

### Entities:
- **Song:** Stores metadata (title, author, key, tempo), lyrics, chords.
- **Setlist:** Links songs with performance order and notes.

### Sync:
- CloudKit CKRecord mirrors Song and Setlist entities.
- Conflict resolution prioritizes latest edit timestamp.

### View Hierarchy:
- **Song Library:** List of songs, searchable, with import/export options.
- **Song Editor:** Text input with chord insertion and metadata fields.
- **Performance View:** Scrollable lyrics/chords, transposition controls.
- **Setlist Manager:** Drag-and-drop song ordering.

### Data Flow:
- User edits song → Saves to CoreData → Queues CloudKit sync.
- Import file → Parses text/ChordPro → Creates Song entity.

## User Experience Flows

- **Adding a Song:** Tap "+" → Enter title, key, lyrics/chords → Save (offline or synced).
- **Performing:** Open setlist → Tap song → View lyrics/chords → Transpose if needed.
- **Importing:** Select text/ChordPro file → Preview → Save to library.
- **Syncing:** Automatic when online; offline changes queued for later.
