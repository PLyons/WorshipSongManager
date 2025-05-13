//
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import SwiftUI
import SwiftData

struct SongDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isEditing = false
    @Bindable var song: Song

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and Artist
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
                        Text("Tempo: \(song.tempo) BPM")
                            .font(.subheadline)
                    }

                    if !song.timeSignature.isEmpty {
                        Text("Time Signature: \(song.timeSignature)")
                            .font(.subheadline)
                    }

                    if !song.copyright.isEmpty {
                        Text("© \(song.copyright)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }

                // Lyrics Section
                if !song.content.isEmpty {
                    Text("Lyrics:")
                        .font(.headline)
                        .padding(.bottom, 4)

                    Text(song.content)
                        .font(.body)
                        .lineSpacing(6)
                        .padding(.bottom)
                }
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
            NavigationStack {
                SongFormView(song: song, isNew: false)
            }
        }
    }
}

// MARK: - Preview Support


#Preview {
    NavigationStack {
        SongDetailView(song: previewSong())
    }
}
