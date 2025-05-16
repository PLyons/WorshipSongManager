# WorshipSongManager MVVM Refactor Checklist

This document tracks the migration of the codebase to a cleaner, testable MVVM architecture. Refactors proceed gradually alongside MVP feature development. Use this as a living checklist.

---

## ✅ Legend

- [x] Completed
- [ ] Not Started
- [~] In Progress
- 🚧 Needs Review

---

## 🧱 Core ViewModel Refactors

| View / Component           | ViewModel Name           | Status  | Notes |
|----------------------------|---------------------------|---------|-------|
| ContentView                | `ContentViewModel`        | [ ]     | Was removed from project |
| SongListView               | `SongListViewModel`       | [x]     | Filtering, sorting, fetch handling complete |
| SongDetailView             | `SongDetailViewModel`     | [x]     | Handles editing, validation, formatting |
| SetlistListView            | `SetlistListViewModel`    | [ ]     | Next candidate for refactor |
| SetlistDetailView          | `SetlistDetailViewModel`  | [ ]     | Song ordering, reordering, drag/drop |
| AddSongView                | `AddSongViewModel`        | [ ]     | Temporary form state and save logic |
| SongPickerView             | `SongPickerViewModel`     | [ ]     | Modal-based filtering/search logic |

---

## ♻️ Reusable Components

| Component Name             | Reuse Context                     | Status  | Notes |
|----------------------------|------------------------------------|---------|-------|
| SongRowView                | List views, search results         | [ ]     | Accepts lightweight view state model |
| SongFormSectionView        | Add/Edit forms                     | [ ]     | Consolidates common fields |
| MetadataSummaryView        | Song detail, performance modes     | [ ]     | Summary card for tempo/key/time |

---

## 🧪 ViewModel Testing Candidates

| ViewModel Name            | Tests Needed                       | Status  | Notes |
|---------------------------|------------------------------------|---------|-------|
| SongListViewModel         | Sorting, filtering logic           | [ ]     | Unit test with mock songs |
| SongDetailViewModel       | Input validation, formatting       | [ ]     | Field validation, content sync |
| SetlistDetailViewModel    | Song ordering, conflict handling   | [ ]     | Ensure stable reordering logic |

---

## 🔄 Navigation Coordination

| Feature Area              | Status  | Notes |
|---------------------------|---------|-------|
| Basic navigation routing  | [ ]     | Evaluate need post-MVP |
| Navigation via state vars | [~]     | Using enum/state toggling in places |

---

## 🛠 Implementation Strategy

- [x] Refactor SongListView and SongDetailView to MVVM
- [x] Use ViewModel observable state for field bindings and logic
- [x] Preview-compatible with mock Core Data store
- [ ] Refactor remaining views incrementally during MVP feature development

---

_Last updated: 2025-05-16_
