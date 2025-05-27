//
//  AddSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//  Modified by Paul Lyons on 5/25/25.
//

import SwiftUI
import CoreData

struct AddSongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var artist = ""
    @State private var key = ""
    @State private var tempo = ""
    @State private var timeSignature = "4/4"
    @State private var copyright = ""
    @State private var content = ""
    @State private var isFavorite = false
    
    // UI State
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var isSaving = false

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

                Section(header: Text("Lyrics and Chords")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("Add Song")
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
            let newSong = Song(context: viewContext)
            newSong.id = UUID()
            newSong.title = title.trimmingCharacters(in: .whitespaces)
            newSong.artist = artist.trimmingCharacters(in: .whitespaces).isEmpty ? nil : artist.trimmingCharacters(in: .whitespaces)
            newSong.key = key.trimmingCharacters(in: .whitespaces)
            newSong.tempo = Int16(tempo) ?? 0
            newSong.timeSignature = timeSignature.isEmpty ? nil : timeSignature
            newSong.copyright = copyright.trimmingCharacters(in: .whitespaces).isEmpty ? nil : copyright.trimmingCharacters(in: .whitespaces)
            newSong.content = content.trimmingCharacters(in: .whitespaces).isEmpty ? nil : content.trimmingCharacters(in: .whitespaces)
            newSong.isFavorite = isFavorite
            newSong.dateCreated = Date()
            newSong.dateModified = Date()

            try viewContext.save()
            dismiss()
            
        } catch {
            errorMessage = "Failed to create new song: \(error.localizedDescription)"
            showingErrorAlert = true
        }
        
        isSaving = false
    }
}

// MARK: - Preview

#Preview {
    AddSongView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
