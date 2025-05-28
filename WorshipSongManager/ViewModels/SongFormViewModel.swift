///
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
    @Published var lyrics: String = "" // Alias for content
    @Published var isFavorite: Bool = false
    @Published var isPublicDomain: Bool = false
    
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
    
    var isEditing: Bool {
        if case .edit = mode {
            return true
        }
        return false
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
        
        // Sync lyrics with content
        setupPropertyBindings()
        
        // Perform initial validation
        validateAllFields()
    }
    
    // MARK: - Property Bindings
    
    private func setupPropertyBindings() {
        // Keep lyrics and content in sync
        $content
            .assign(to: &$lyrics)
    }
    
    // MARK: - Public Methods
    
    func save() async -> Bool {
        guard validateAllFields() && isValid else {
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await saveSong()
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
        case .lyrics:
            // Lyrics/content validation is optional
            break
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
        lyrics = content // Keep in sync
        isFavorite = song.isFavorite
        isPublicDomain = copyright.isEmpty // Assume public domain if no copyright
    }
    
    private func clearForm() {
        title = ""
        artist = ""
        key = ""
        tempo = ""
        timeSignature = "4/4"
        copyright = ""
        content = ""
        lyrics = ""
        isFavorite = false
        isPublicDomain = false
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
        song.tempo = safeTempoValue
        song.timeSignature = timeSignature.isEmpty ? "4/4" : timeSignature
        song.copyright = isPublicDomain ? nil : (copyright.trimmingCharacters(in: .whitespaces).isEmpty ? nil : copyright.trimmingCharacters(in: .whitespaces))
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
        removeValidationErrors(containing: "Title")
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        
        if trimmedTitle.isEmpty {
            addValidationError("Title is required")
        } else if trimmedTitle.count > 100 {
            addValidationError("Title must be less than 100 characters")
        }
    }
    
    private func validateKey() {
        removeValidationErrors(containing: "Key")
        
        let trimmedKey = key.trimmingCharacters(in: .whitespaces)
        
        if trimmedKey.isEmpty {
            addValidationError("Key is required")
        } else {
            // Optional: Validate against common worship keys
            let validKeys = ["C", "C#", "Db", "D", "D#", "Eb", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"]
            if !validKeys.contains(trimmedKey) {
                // Could add a gentle suggestion here if desired
                // addValidationError("Consider using a standard key (C, D, E, F, G, A, B)")
            }
        }
    }
    
    private func validateTempo() {
        removeValidationErrors(containing: ["Tempo", "BPM"])
        
        let trimmedTempo = tempo.trimmingCharacters(in: .whitespaces)
        
        // Tempo is optional - return early if empty
        guard !trimmedTempo.isEmpty else { return }
        
        guard let tempoValue = Int(trimmedTempo) else {
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
        removeValidationErrors(containing: "Artist")
        
        if artist.count > 100 {
            addValidationError("Artist name must be less than 100 characters")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Removes validation errors containing any of the specified substrings
    private func removeValidationErrors(containing substrings: [String]) {
        validationErrors.removeAll { error in
            substrings.contains { error.contains($0) }
        }
    }
    
    /// Removes validation errors containing the specified substring
    private func removeValidationErrors(containing substring: String) {
        removeValidationErrors(containing: [substring])
    }
    
    /// Adds a validation error if it doesn't already exist
    private func addValidationError(_ message: String) {
        if !validationErrors.contains(message) {
            validationErrors.append(message)
        }
    }
    
    // MARK: - Safe Tempo Conversion
    
    /// Safely converts tempo string to Int16, handling invalid inputs
    private var safeTempoValue: Int16 {
        let cleanedTempo = tempo.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Return 0 for empty tempo (means "not set")
        guard !cleanedTempo.isEmpty else { return 0 }
        
        // Convert safely with bounds checking
        guard let tempoInt = Int(cleanedTempo),
              tempoInt >= 0,
              tempoInt <= Int(Int16.max) else {
            return 0
        }
        
        return Int16(tempoInt)
    }
}

// MARK: - Supporting Types

enum SongField {
    case title, artist, key, tempo, lyrics
}
