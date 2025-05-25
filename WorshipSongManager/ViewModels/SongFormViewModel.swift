//
//  SongFormViewModel.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-25
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class SongFormViewModel: ObservableObject {
    
    // MARK: - Mode Definition
    enum Mode {
        case add
        case edit(Song)
        
        var title: String {
            switch self {
            case .add:
                return "Add Song"
            case .edit:
                return "Edit Song"
            }
        }
        
        var saveButtonTitle: String {
            switch self {
            case .add:
                return "Create"
            case .edit:
                return "Save Changes"
            }
        }
    }
    
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    private let mode: Mode
    private let originalSong: Song?
    
    // MARK: - Published Properties (Form Fields)
    @Published var title: String = ""
    @Published var artist: String = ""
    @Published var key: String = ""
    @Published var tempo: String = ""
    @Published var timeSignature: String = "4/4"
    @Published var copyright: String = ""
    @Published var content: String = ""
    @Published var isFavorite: Bool = false
    
    // MARK: - Published Properties (UI State)
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingErrorAlert: Bool = false
    @Published var validationErrors: [String] = []
    
    // MARK: - Computed Properties
    var navigationTitle: String {
        mode.title
    }
    
    var saveButtonTitle: String {
        mode.saveButtonTitle
    }
    
    var isValid: Bool {
        validationErrors.isEmpty &&
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !key.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext, mode: Mode) {
        self.context = context
        self.mode = mode
        
        switch mode {
        case .add:
            self.originalSong = nil
            setupDefaultValues()
            
        case .edit(let song):
            self.originalSong = song
            populateFields(from: song)
        }
        
        // Perform initial validation
        validateAllFields()
    }
    
    // MARK: - Public Methods
    
    func save() async -> Bool {
        guard validateAllFields() && isValid else {
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let song = try await saveSong()
            try context.save()
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to save song: \(error.localizedDescription)"
            showingErrorAlert = true
            isLoading = false
            return false
        }
    }
    
    func cancel() {
        // Reset form to original values if editing
        if case .edit(let song) = mode {
            populateFields(from: song)
        } else {
            // Clear form if adding
            clearForm()
        }
        validateAllFields()
    }
    
    func validateField(_ field: SongField) {
        switch field {
        case .title:
            validateTitle()
        case .key:
            validateKey()
        case .tempo:
            validateTempo()
        case .artist:
            validateArtist()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultValues() {
        timeSignature = "4/4"
        tempo = ""
        isFavorite = false
    }
    
    private func populateFields(from song: Song) {
        title = song.title ?? ""
        artist = song.artist ?? ""
        key = song.key ?? ""
        tempo = song.tempo > 0 ? String(song.tempo) : ""
        timeSignature = song.timeSignature ?? "4/4"
        copyright = song.copyright ?? ""
        content = song.content ?? ""
        isFavorite = song.isFavorite
    }
    
    private func clearForm() {
        title = ""
        artist = ""
        key = ""
        tempo = ""
        timeSignature = "4/4"
        copyright = ""
        content = ""
        isFavorite = false
    }
    
    private func saveSong() async throws -> Song {
        let song: Song
        
        switch mode {
        case .add:
            song = Song(context: context)
            song.dateCreated = Date()
            
        case .edit(let existingSong):
            song = existingSong
        }
        
        // Update song properties with data sanitization
        song.title = title.trimmingCharacters(in: .whitespaces)
        song.artist = artist.trimmingCharacters(in: .whitespaces).isEmpty ? nil : artist.trimmingCharacters(in: .whitespaces)
        song.key = key.trimmingCharacters(in: .whitespaces)
        song.tempo = Int16(tempo) ?? 0
        song.timeSignature = timeSignature.isEmpty ? "4/4" : timeSignature
        song.copyright = copyright.trimmingCharacters(in: .whitespaces).isEmpty ? nil : copyright.trimmingCharacters(in: .whitespaces)
        song.content = content.trimmingCharacters(in: .whitespaces).isEmpty ? nil : content.trimmingCharacters(in: .whitespaces)
        song.isFavorite = isFavorite
        song.dateModified = Date()
        
        return song
    }
    
    // MARK: - Validation Methods
    
    @discardableResult
    private func validateAllFields() -> Bool {
        validationErrors.removeAll()
        
        validateTitle()
        validateKey()
        validateTempo()
        validateArtist()
        
        return validationErrors.isEmpty
    }
    
    private func validateTitle() {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            addValidationError("Title is required")
        } else if title.trimmingCharacters(in: .whitespaces).count > 100 {
            addValidationError("Title must be less than 100 characters")
        }
    }
    
    private func validateKey() {
        if key.trimmingCharacters(in: .whitespaces).isEmpty {
            addValidationError("Key is required")
        } else {
            // Validate common worship keys
            let validKeys = ["C", "C#", "Db", "D", "D#", "Eb", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"]
            let trimmedKey = key.trimmingCharacters(in: .whitespaces)
            
            if !validKeys.contains(trimmedKey) {
                // Don't block saving, but suggest common keys
                // This is just a gentle suggestion, not a hard error
            }
        }
    }
    
    private func validateTempo() {
        guard !tempo.isEmpty else { return } // Tempo is optional
        
        guard let tempoValue = Int(tempo) else {
            addValidationError("Tempo must be a number")
            return
        }
        
        if tempoValue < 40 {
            addValidationError("Tempo seems too slow (minimum 40 BPM recommended)")
        } else if tempoValue > 300 {
            addValidationError("Tempo seems too fast (maximum 300 BPM recommended)")
        }
    }
    
    private func validateArtist() {
        if artist.count > 100 {
            addValidationError("Artist name must be less than 100 characters")
        }
    }
    
    private func addValidationError(_ message: String) {
        if !validationErrors.contains(message) {
            validationErrors.append(message)
        }
    }
}

// MARK: - Supporting Types

enum SongField {
    case title, artist, key, tempo
}
