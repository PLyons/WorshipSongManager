//
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import SwiftData

struct SongDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var song: Song
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and artist
                VStack(alignment: .leading, spacing: 8) {
                    Text(song.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if !song.artist.isEmpty {
                        Text(song.artist)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }

                    if !song.key.isEmpty {
                        Text("Key: \(song.key)")
                            .font(.headline)
                    }

                    if song.tempo > 0 {
                        Text("Tempo: \(song.tempo)")
                            .font(.subheadline)
                    }

                    if !song.timeSignature.isEmpty {
                        Text("Time Signature: \(song.timeSignature)")
                            .font(.subheadline)
                    }
                }
                .padding(.bottom)

                // Lyrics
                if !song.content.isEmpty {
                    Text("Lyrics:")
                        .font(.headline)
                        .padding(.bottom, 4)

                    Text(song.content)
                        .font(.body)
                        .lineSpacing(5)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Song Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditSongView(song: song)
        }
    }
}

// Preview wrapper using @State for @Bindable compatibility
struct SongDetailView_PreviewWrapper: View {
    @State private var song = Song(
        title: "Sample Title",
        artist: "Sample Artist",
        key: "D",
        tempo: 100,
        timeSignature: "3/4",
        copyright: "© 2025",
        content: "Amazing grace, how sweet the sound\nThat saved a wretch like me...",
        isFavorite: true
    )

    var body: some View {
        NavigationStack {
            SongDetailView(song: song)
        }
    }
}

#Preview {
    SongDetailView_PreviewWrapper()
        .modelContainer(previewModelContainer())
}
