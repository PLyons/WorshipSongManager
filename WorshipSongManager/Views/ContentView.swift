//
//  ContentView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Song.title) private var songs: [Song]
    
    @State private var isShowingAddSong = false
    
    var body: some View {
        NavigationView {
            Group {
                if songs.isEmpty {
                    ContentUnavailableView(
                        "No Songs",
                        systemImage: "music.note.list",
                        description: Text("Tap + to add your first song.")
                    )
                } else {
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
                }
            }
            .navigationTitle("Songs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddSong = true }) {
                        Label("Add Song", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isShowingAddSong) {
                AddSongView()
            }
            
            Text("Select a Song")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
    
    private func deleteSongs(at offsets: IndexSet) {
        for index in offsets {
            let song = songs[index]
            modelContext.delete(song)
        }
        try? modelContext.save()
    }
}
