//
//  SongListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import CoreData

struct SongListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddSong = false
    @State private var searchText = ""
    @State private var sortByTitle = true

    @FetchRequest(
        entity: Song.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default
    )
    private var allSongs: FetchedResults<Song>

    var filteredAndSortedSongs: [Song] {
        let filtered = allSongs.filter {
            searchText.isEmpty ||
            ($0.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.artist?.localizedCaseInsensitiveContains(searchText) ?? false)
        }

        return filtered.sorted {
            sortByTitle ?
                ($0.title ?? "") < ($1.title ?? "") :
                ($0.dateCreated ?? Date.distantPast) > ($1.dateCreated ?? Date.distantPast)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredAndSortedSongs) { song in
                    NavigationLink(destination: EditSongView(song: song)) {
                        VStack(alignment: .leading) {
                            Text(song.title ?? "Untitled")
                                .font(.headline)

                            if let artist = song.artist, !artist.isEmpty {
                                Text(artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSongs)
            }
            .navigationTitle("Songs")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSong = true
                    } label: {
                        Label("Add Song", systemImage: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Sort", selection: $sortByTitle) {
                        Text("Title").tag(true)
                        Text("Newest").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .sheet(isPresented: $showingAddSong) {
                AddSongView()
            }
        }
    }

    private func deleteSongs(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(filteredAndSortedSongs[index])
        }

        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to delete songs: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let previewSong = Song(context: context)
    previewSong.title = "Amazing Grace"
    previewSong.artist = "John Newton"
    previewSong.key = "G"
    previewSong.tempo = 90
    previewSong.timeSignature = "3/4"
    previewSong.copyright = "Public Domain"
    previewSong.content = "[G] Amazing [C] Grace"
    previewSong.isFavorite = true
    previewSong.dateCreated = Date()

    return SongListView()
        .environment(\.managedObjectContext, context)
}
