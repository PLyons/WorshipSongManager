//
//  SetlistDetailViewModel.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-25
//  Modified by Paul Lyons on 2025-05-27
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class SongDetailViewModel: ObservableObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    private let originalSong: Song

    // MARK: - Editable Properties
    @Published var title: String
    @Published var artist: String
    @Published var key: String
    @Published var tempo: String
    @Published var timeSignature: String
    @Published var content: String
    @Published var isFavorite: Bool
    @Published var isEditing: Bool = false
    @Published var validationMessage: String?

    // MARK: - Expose the song for external access
    var song: Song {
        originalSong
    }

    // MARK: - Init
    init(song: Song, context: NSManagedObjectContext) {
        self.context = context
        self.originalSong = song

        self.title = song.title ?? ""
        self.artist = song.artist ?? ""
        self.key = song.key ?? ""
        self.tempo = String(song.tempo)
        self.timeSignature = song.timeSignature ?? ""
        self.content = song.content ?? ""
        self.isFavorite = song.isFavorite
    }

    // MARK: - Save Logic
    func saveChanges() -> Bool {
        guard validateFields() else { return false }

        originalSong.title = title
        originalSong.artist = artist
        originalSong.key = key
        originalSong.tempo = Int16(tempo) ?? 0
        originalSong.timeSignature = timeSignature
        originalSong.content = content
        originalSong.isFavorite = isFavorite

        do {
            try context.save()
            return true
        } catch {
            print("❌ Error saving song: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Cancel Logic
    func cancelChanges() {
        title = originalSong.title ?? ""
        artist = originalSong.artist ?? ""
        key = originalSong.key ?? ""
        tempo = String(originalSong.tempo)
        timeSignature = originalSong.timeSignature ?? ""
        content = originalSong.content ?? ""
        isFavorite = originalSong.isFavorite
    }

    // MARK: - Validation
    private func validateFields() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            validationMessage = "Title is required."
            return false
        }

        if let bpm = Int(tempo), bpm <= 0 {
            validationMessage = "Tempo must be a positive number."
            return false
        } else if Int(tempo) == nil && !tempo.isEmpty {
            validationMessage = "Tempo must be numeric."
            return false
        }

        validationMessage = nil
        return true
    }
}
