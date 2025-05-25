# Worship Song Manager

Worship Song Manager is an iOS application designed to help worship teams and leaders store, organize, and perform songs. It aims to replace traditional paper charts and binders with a streamlined digital solution, offering support for lyrics, chords, setlists, and eventually, features like transposition and multi-device synchronization.

## Key Features

**Current (as of May 2025):**
*   Song library management (create, edit, delete songs with lyrics and metadata).
*   Core Data persistence with CloudKit synchronization for offline access and multi-device data consistency.
*   MVVM architecture in progress for improved maintainability and testability.
*   Basic setlist creation and song assignment.
*   Support for SwiftUI Previews with mock data for easier development.

**Planned (MVP & Beyond):**
*   Full setlist management (reordering, detailed editing).
*   Markdown and text-based song file import/export (ChordPro planned).
*   Chord transposition and capo mode.
*   Enhanced performance mode with features like auto-scroll and customizable display.
*   Advanced tagging and filtering for songs.
*   (Future) Real-time multi-device performance synchronization.
*   (Future) macOS support.

For more detailed internal documentation, please refer to the files within the `WorshipSongManager/Markdown Files/` directory.

## Technologies Used

*   **UI Framework:** SwiftUI
*   **Data Management:** Core Data
*   **Cloud Sync:** CloudKit (via `NSPersistentCloudKitContainer`)
*   **Target iOS Version:** iOS 17.0+
*   **IDE:** Xcode

## Current Status

The project is actively under development by PLyons, with a focus on completing Minimum Viable Product (MVP) features. Key recent efforts include migrating to Core Data, implementing core song and setlist functionalities, and refactoring towards an MVVM architecture.

*(This README was last updated on 2025-05-25).* 
