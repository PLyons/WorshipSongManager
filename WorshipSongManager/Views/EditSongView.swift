//
//  EditSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import SwiftData

struct EditSongView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var song: Song

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("Title", text: $song.title)
                    TextField("Artist", text: $song.artist)
                    TextField("Key", text: $song.key)
                    Toggle("Favorite", isOn: $song.isFavorite)
                }

                Section(header: Text("Lyrics")) {
                    TextEditor(text: $song.content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("Edit Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateSong()
                    }
                    .disabled(song.title.isEmpty)
                }
            }
        }
    }

    private func updateSong() {
        withAnimation {
            song.dateModified = Date()
            do {
                try modelContext.save()
                dismiss()
            } catch {
                print("Error updating song: \(error.localizedDescription)")
            }
        }
    }
}

struct EditSongView_PreviewWrapper: View {
    @State private var song = Song(
        title: "Sample Title",
        artist: "Sample Artist",
        key: "C",
        tempo: 80,
        timeSignature: "4/4",
        copyright: "© 2025",
        content: "Sample lyrics go here...",
        isFavorite: true
    )

    var body: some View {
        EditSongView(song: song)
    }
}

#Preview {
    EditSongView_PreviewWrapper()
        .modelContainer(previewModelContainer())
}
