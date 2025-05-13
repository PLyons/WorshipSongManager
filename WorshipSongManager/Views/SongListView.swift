//
//  SongListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
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
        try? modelContext.save()
    }
}

#Preview {
    SongListView()
        .modelContainer(previewModelContainer())
}
