//
//  SetlistDetailViewModel.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-25
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class SetlistDetailViewModel: ObservableObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    let setlist: Setlist  // Make this public so views can access it
    
    // MARK: - Published Properties
    @Published var songs: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingErrorAlert: Bool = false
    @Published var showingSongPicker: Bool = false
    @Published var isEditing: Bool = false
    
    // MARK: - Computed Properties
    var setlistName: String {
        setlist.name ?? "Untitled Setlist"
    }
    
    var setlistDate: Date? {
        setlist.date
    }
    
    var songCount: Int {
        songs.count
    }
    
    var isEmpty: Bool {
        songs.isEmpty
    }
    
    // MARK: - Initialization
    init(setlist: Setlist, context: NSManagedObjectContext) {
        self.setlist = setlist
        self.context = context
        loadSongs()
    }
    
    // MARK: - Public Methods
    
    func refreshSongs() {
        loadSongs()
    }
    
    func toggleEditMode() {
        isEditing.toggle()
    }
    
    func addSongs(_ songsToAdd: [Song]) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            for song in songsToAdd {
                // Avoid duplicates
                if !songs.contains(song) {
                    setlist.addToSongs(song)
                }
            }
            
            try context.save()
            loadSongs() // Refresh the list
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to add songs to setlist: \(error.localizedDescription)"
            showingErrorAlert = true
            isLoading = false
            return false
        }
    }
    
    func removeSongs(at offsets: IndexSet) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let songsToRemove = offsets.map { songs[$0] }
            
            for song in songsToRemove {
                setlist.removeFromSongs(song)
            }
            
            try context.save()
            loadSongs() // Refresh the list
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to remove songs from setlist: \(error.localizedDescription)"
            showingErrorAlert = true
            isLoading = false
            return false
        }
    }
    
    func reorderSongs(from source: IndexSet, to destination: Int) {
        // Reorder the local array
        songs.move(fromOffsets: source, toOffset: destination)
        
        // Save the new order to Core Data
        Task {
            await saveNewOrder()
        }
    }
    
    func updateSetlistInfo(name: String, date: Date, notes: String?) async -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Setlist name cannot be empty"
            showingErrorAlert = true
            return false
        }
        
        isLoading = true
        
        do {
            setlist.name = name.trimmingCharacters(in: .whitespaces)
            setlist.date = date
            setlist.notes = notes?.trimmingCharacters(in: .whitespaces).isEmpty == true ? nil : notes?.trimmingCharacters(in: .whitespaces)
            setlist.dateModified = Date()
            
            try context.save()
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to update setlist: \(error.localizedDescription)"
            showingErrorAlert = true
            isLoading = false
            return false
        }
    }
    
    func clearError() {
        errorMessage = nil
        showingErrorAlert = false
    }
    
    // MARK: - Private Methods
    
    private func loadSongs() {
        // Convert the Core Data set to a sorted array
        let songSet = setlist.songs as? Set<Song> ?? []
        songs = songSet.sorted { song1, song2 in
            // Sort by title as default - in future we could add position ordering
            (song1.title ?? "") < (song2.title ?? "")
        }
    }
    
    private func saveNewOrder() async {
        // For now, we'll just save the context
        // In a future enhancement, we could implement SetlistItem with position tracking
        do {
            try context.save()
        } catch {
            await MainActor.run {
                errorMessage = "Failed to save song order: \(error.localizedDescription)"
                showingErrorAlert = true
            }
        }
    }
}

// MARK: - Computed Properties Extension

extension SetlistDetailViewModel {
    var formattedDate: String {
        guard let date = setlistDate else { return "No date set" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    var songCountText: String {
        switch songCount {
        case 0:
            return "No songs"
        case 1:
            return "1 song"
        default:
            return "\(songCount) songs"
        }
    }
}
