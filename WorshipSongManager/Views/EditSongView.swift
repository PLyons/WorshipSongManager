//
//  EditSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/15/25.
//  Modified by Paul Lyons on 05/15/25
//

import SwiftUI
import CoreData

struct EditSongView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var song: Song

    @State private var title: String
    @State private var artist: String
    @State private var key: String
    @State private var tempo: String
    @State private var timeSignature: String
    @State private var copyright: String
    @State private var content: String
    @State private var isFavorite: Bool
    
    // UI State
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var isSaving = false

    init(song: Song) {
        self.song = song
        _title = State(initialValue: song.title ?? "")
        _artist = State(initialValue: song.artist ?? "")
        _key = State(initialValue: song.key ?? "")
        _tempo = State(initialValue: String(song.tempo))
        _timeSignature = State(initialValue: song.timeSignature ?? "")
        _copyright = State(initialValue: song.copyright ?? "")
        _content = State(initialValue: song.content ?? "")
        _isFavorite = State(initialValue: song.isFavorite)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Key", text: $key)
                    TextField("Tempo", text: $tempo)
                        .keyboardType(.numberPad)
                    TextField("Time Signature", text: $timeSignature)
                    TextField("Copyright", text: $copyright)
                    Toggle("Favorite", isOn: $isFavorite)
                }

                Section(header: Text("Lyrics or Chord Chart")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("Edit Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isSaving)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveSong()
                        }
                    }
                    .disabled(!isValid || isSaving)
                }
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !key.trimmingCharacters(in: .whitespaces).isEmpty &&
        isTempoValid
    }
    
    private var isTempoValid: Bool {
        if tempo.isEmpty { return true } // Tempo is optional
        guard let tempoValue = Int(tempo) else { return false }
        return tempoValue > 0 && tempoValue <= 300 // Reasonable BPM range
    }
    
    // MARK: - Methods
    
    @MainActor
    private func saveSong() async {
        guard isValid else { return }
        
        isSaving = true
        
        do {
            // Update song properties
            song.title = title.trimmingCharacters(in: .whitespaces)
            song.artist = artist.trimmingCharacters(in: .whitespaces).isEmpty ? nil : artist.trimmingCharacters(in: .whitespaces)
            song.key = key.trimmingCharacters(in: .whitespaces)
            song.tempo = Int16(tempo) ?? 0
            song.timeSignature = timeSignature.isEmpty ? nil : timeSignature
            song.copyright = copyright.trimmingCharacters(in: .whitespaces).isEmpty ? nil : copyright.trimmingCharacters(in: .whitespaces)
            song.content = content.trimmingCharacters(in: .whitespaces).isEmpty ? nil : content.trimmingCharacters(in: .whitespaces)
            song.isFavorite = isFavorite
            song.dateModified = Date()
            
            // Save to Core Data
            try viewContext.save()
            
            // Success - dismiss view
            dismiss()
            
        } catch {
            // Handle save error
            errorMessage = "Failed to save song changes: \(error.localizedDescription)"
            showingErrorAlert = true
        }
        
        isSaving = false
    }
    
    private func resetForm() {
        title = song.title ?? ""
        artist = song.artist ?? ""
        key = song.key ?? ""
        tempo = String(song.tempo)
        timeSignature = song.timeSignature ?? ""
        copyright = song.copyright ?? ""
        content = song.content ?? ""
        isFavorite = song.isFavorite
    }
}

// MARK: - Preview

struct EditSongView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        let song = Song(context: context)
        song.title = "Preview Song"
        song.artist = "Preview Artist"
        song.key = "G"
        song.tempo = 90
        song.timeSignature = "4/4"
        song.content = "Lyrics here"
        song.dateCreated = Date()
        song.dateModified = Date()
        
        return EditSongView(song: song)
            .environment(\.managedObjectContext, context)
    }
}
