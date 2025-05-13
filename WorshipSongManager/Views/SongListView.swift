//
//  SongListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//

import SwiftUI
import SwiftData

struct SongListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Song.title) private var songs: [Song]
    
    @State private var showAddSong = false

    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    NavigationLink(destination: SongDetailView(song: song)) {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            
                            if !song.artist.isEmpty {
                                Text(song.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSongs)
            }
            .navigationTitle("Songs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddSong = true }) {
                        Label("Add Song", systemImage: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddSong) {
                AddSongView()
            }
        }
    }

    private func deleteSongs(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(songs[index])
        }
    }
}

/*
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Song.self, configurations: config)

    let example = Song(
        title: "Amazing Grace",
        artist: "John Newton",
        key: "G",
        tempo: 80,
        timeSignature: "3/4",
        copyright: "Public Domain",
        content: "Amazing grace! How sweet the sound...",
        isFavorite: true,
        dateCreated: Date(),
        dateModified: Date()
    )

    container.mainContext.insert(example)

    return SongListView()
        .modelContainer(container)
}
*/

