//
//  SongListViewModel.swift
//  WorshipSongManager
//
//  Created by Architect on 5/15/25.
//

import Foundation
import CoreData
import Combine

@MainActor
final class SongListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext

    // MARK: - Published Properties
    @Published var allSongs: [Song] = []
    @Published var searchText: String = ""
    @Published var showAddSongSheet: Bool = false

    // MARK: - Computed Filtered Songs
    var filteredSongs: [Song] {
        guard !searchText.isEmpty else { return allSongs }
        let lowercasedQuery = searchText.lowercased()
        return allSongs.filter {
            ($0.title ?? "").lowercased().contains(lowercasedQuery) ||
            ($0.artist ?? "").lowercased().contains(lowercasedQuery)
        }
    }

    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Fetching
    func fetchSongs() {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Song.title, ascending: true)
        ]

        do {
            allSongs = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch songs: \(error.localizedDescription)")
            allSongs = []
        }
    }

    // MARK: - Deletion
    func deleteSongs(at offsets: IndexSet) {
        for index in offsets {
            let song = filteredSongs[index]
            context.delete(song)
        }

        saveChanges()
        fetchSongs() // Refresh list after deletion
    }

    // MARK: - Save
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save context after deletion: \(error.localizedDescription)")
        }
    }
}
