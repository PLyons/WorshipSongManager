//
//  SongPickerViewModel.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-28
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class SongPickerViewModel: ObservableObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    private let setlist: Setlist
    
    // MARK: - Published Properties
    @Published var songs: [Song] = []
    @Published var filteredSongs: [Song] = []
    @Published var selectedSongs: Set<Song> = []
    @Published var searchText: String = "" {
        didSet {
            filterSongs()
        }
    }
    
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingErrorAlert: Bool = false
    
    // MARK: - Computed Properties
    var hasSelectedSongs: Bool {
        !selectedSongs.isEmpty
    }
    
    var selectAllButtonTitle: String {
        selectedSongs.count == filteredSongs.count ? "Deselect All" : "Select All"
    }
    
    var saveButtonTitle: String {
        "Add \(selectedSongs.count) Song\(selectedSongs.count == 1 ? "" : "s")"
    }
    
    var availableForSelection: [Song] {
        // Only show songs not already in the setlist
        let currentSongIDs = Set(setlist.songsArray.map { $0.objectID })
        return songs.filter { !currentSongIDs.contains($0.objectID) }
    }
    
    // MARK: - Initialization
    init(setlist: Setlist, context: NSManagedObjectContext) {
        self.setlist = setlist
        self.context = context
        
        Task {
            await fetchSongs()
        }
    }
    
    // MARK: - Data Operations
    func fetchSongs() async {
        isLoading = true
        clearError()
        
        do {
            let request: NSFetchRequest<Song> = Song.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \Song.title, ascending: true)
            ]
            
            let fetchedSongs = try context.fetch(request)
            
            // Update on main thread
            await MainActor.run {
                self.songs = fetchedSongs
                self.filterSongs()
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.handleError("Failed to load songs: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func saveSelectedSongs() async -> Bool {
        guard !selectedSongs.isEmpty else {
            handleError("No songs selected")
            return false
        }
        
        isLoading = true
        clearError()
        
        do {
            // Add selected songs to the setlist
            for song in selectedSongs {
                let setlistItem = SetlistItem(context: context)
                setlistItem.song = song
                setlistItem.setlist = setlist
                setlistItem.position = Int16(setlist.songsArray.count)
                setlistItem.dateCreated = Date()
                setlistItem.dateModified = Date()
            }
            
            // Update setlist modification date
            setlist.dateModified = Date()
            
            // Save to Core Data
            try context.save()
            
            await MainActor.run {
                self.isLoading = false
                self.selectedSongs.removeAll()
            }
            
            return true
            
        } catch {
            await MainActor.run {
                self.handleError("Failed to add songs: \(error.localizedDescription)")
                self.isLoading = false
            }
            return false
        }
    }
    
    // MARK: - Selection Management
    func toggleSong(_ song: Song) {
        if selectedSongs.contains(song) {
            selectedSongs.remove(song)
        } else {
            selectedSongs.insert(song)
        }
    }
    
    func selectAllVisibleSongs() {
        if selectedSongs.count == filteredSongs.count {
            // Deselect all
            selectedSongs.removeAll()
        } else {
            // Select all visible songs
            selectedSongs = Set(filteredSongs)
        }
    }
    
    func isSelected(_ song: Song) -> Bool {
        selectedSongs.contains(song)
    }
    
    func isSongInSetlist(_ song: Song) -> Bool {
        let currentSongIDs = Set(setlist.songsArray.map { $0.objectID })
        return currentSongIDs.contains(song.objectID)
    }
    
    // MARK: - Search and Filtering
    private func filterSongs() {
        if searchText.isEmpty {
            filteredSongs = availableForSelection
        } else {
            let searchTerm = searchText.lowercased()
            filteredSongs = availableForSelection.filter { song in
                let title = song.title?.lowercased() ?? ""
                let artist = song.artist?.lowercased() ?? ""
                let key = song.key?.lowercased() ?? ""
                
                return title.contains(searchTerm) ||
                       artist.contains(searchTerm) ||
                       key.contains(searchTerm)
            }
        }
        
        // Remove songs that are no longer visible from selection
        selectedSongs = selectedSongs.intersection(Set(filteredSongs))
    }
    
    // MARK: - Error Handling
    private func handleError(_ message: String) {
        errorMessage = message
        showingErrorAlert = true
    }
    
    func clearError() {
        errorMessage = nil
        showingErrorAlert = false
    }
}

// MARK: - Setlist Extension for Helper Property
extension Setlist {
    var songsArray: [Song] {
        let items = items?.allObjects as? [SetlistItem] ?? []
        return items
            .sorted { $0.position < $1.position }
            .compactMap { $0.song }
    }
}
