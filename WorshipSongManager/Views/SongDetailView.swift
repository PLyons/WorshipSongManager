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
    let song: Song
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and artist section
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
                }
                .padding(.bottom)

                // Content section
                if !song.content.isEmpty {
                    Text("Lyrics:")
                        .font(.headline)
                        .padding(.bottom, 4)

                    Text(song.content)
                        .font(.body)
                        .lineSpacing(8)
                } else {
                    Text("No lyrics added")
                        .foregroundColor(.secondary)
                        .italic()
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Song Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing = true }) {
                    Text("Edit")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFavorite) {
                    Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditSongView(song: song)
        }
    }

    private func toggleFavorite() {
        song.isFavorite.toggle()

        do {
            try modelContext.save()
        } catch {
            print("Error toggling favorite: \(error.localizedDescription)")
        }
    }
}
