//
//  ContentView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    @State private var isShowingAddSong = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    NavigationLink(destination: SongDetailView(song: song)) {
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
            
            // Placeholder for detail view when no song is selected
            Text("Select a Song")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
    
    private func deleteSongs(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
