//
//  AddSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//  Modified by Paul Lyons on 5/13/25.
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
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSong()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || key.isEmpty)
                }
            }
        }
    }

    private func saveSong() {
        let newSong = Song(context: viewContext)
        newSong.title = title
        newSong.artist = artist
        newSong.key = key
        newSong.tempo = Int16(tempo) ?? 120
        newSong.timeSignature = timeSignature
        newSong.copyright = copyright
        newSong.content = content
        newSong.isFavorite = isFavorite
        newSong.dateCreated = Date()
        newSong.dateModified = Date()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("❌ Failed to save new song: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview {
    AddSongView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
