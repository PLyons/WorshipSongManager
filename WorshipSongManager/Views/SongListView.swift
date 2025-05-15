//
//  SongListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct SongListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>

    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    NavigationLink(destination: SongDetailView(song: song)) {
                        VStack(alignment: .leading) {
                            Text(song.title ?? "Untitled")
                                .font(.headline)
                            if let artist = song.artist {
                                Text(artist).font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewContext.delete(song)
                            try? viewContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            // Launch Edit View
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle("All Songs")
        }
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
            .environment(\.managedObjectContext, PreviewPersistenceController.shared.viewContext)
    }
}

