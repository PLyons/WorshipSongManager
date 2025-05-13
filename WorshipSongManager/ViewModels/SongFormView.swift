//
//  SongFormView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import SwiftData

struct SongFormView: View {
    @Bindable var song: Song

    var body: some View {
        Form {
            Section(header: Text("Song Details")) {
                TextField("Title", text: $song.title)
                TextField("Artist", text: $song.artist)
                TextField("Key", text: $song.key)
                TextField("Tempo", value: $song.tempo, formatter: NumberFormatter())
                TextField("Time Signature", text: $song.timeSignature)
                TextField("Copyright", text: $song.copyright)
                Toggle("Favorite", isOn: $song.isFavorite)
            }

            Section(header: Text("Lyrics")) {
                TextEditor(text: $song.content)
                    .frame(minHeight: 150)
            }
        }
        .navigationTitle("Edit Song")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview wrapper for @Bindable + SwiftData
struct SongFormView_PreviewWrapper: View {
    @State private var song = Song(
        title: "Preview Title",
        artist: "Preview Artist",
        key: "A",
        tempo: 80,
        timeSignature: "4/4",
        copyright: "© Preview",
        content: "Sample lyrics here...",
        isFavorite: false
    )

    var body: some View {
        NavigationStack {
            SongFormView(song: song)
        }
    }
}

#Preview {
    SongFormView_PreviewWrapper()
        .modelContainer(previewModelContainer())
}
