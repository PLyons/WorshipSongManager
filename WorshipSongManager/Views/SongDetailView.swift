//
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct SongDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var song: Song
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(song.title ?? "Untitled")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let artist = song.artist, !artist.isEmpty {
                    Text(artist)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                if let key = song.key, !key.isEmpty {
                    Text("Key: \(key)").font(.headline)
                }

                Text(song.content ?? "")
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Song Detail")
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

struct SongDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        let song = Song(context: context)
        song.title = "Sample Song"
        song.artist = "Sample Artist"
        song.key = "C"
        song.content = "Amazing grace how sweet the sound"
        return NavigationView {
            SongDetailView(song: song)
        }
    }
}
