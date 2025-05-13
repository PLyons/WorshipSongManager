//
//  SongFormView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//

import SwiftUI
import SwiftData

struct SongFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var song: Song
    var isNew: Bool

    var body: some View {
        Form {
            Section(header: Text("Song Info")) {
                TextField("Title", text: $song.title)
                TextField("Artist", text: $song.artist)
                TextField("Key", text: $song.key)
                TextField("Tempo", value: $song.tempo, format: .number)
                TextField("Time Signature", text: $song.timeSignature)
                TextField("Copyright", text: $song.copyright)
                Toggle("Favorite", isOn: $song.isFavorite)
            }

            Section(header: Text("Lyrics & Chords")) {
                TextEditor(text: $song.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle(isNew ? "Add Song" : "Edit Song")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if isNew {
                        modelContext.delete(song)
                    }
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    song.dateModified = Date()
                    if isNew {
                        song.dateCreated = Date()
                    }
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Preview Support

#Preview("Edit Song") {
    NavigationStack {
        SongFormView(song: previewSong(), isNew: false)
    }
}

#Preview("Add Song") {
    NavigationStack {
        SongFormView(song: Song(), isNew: true)
    }
}
