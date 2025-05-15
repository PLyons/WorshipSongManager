//
//  SongPickerView.swift
//  WorshipSongManager
//
//  Created by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct SongPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var setlist: Setlist
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var allSongs: FetchedResults<Song>

    var body: some View {
        NavigationView {
            List {
                ForEach(allSongs) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title ?? "Untitled")
                                .font(.headline)
                            if let artist = song.artist {
                                Text(artist).font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        if setlist.songs?.contains(song) == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSong(song)
                    }
                }
            }
            .navigationTitle("Add Songs")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        try? viewContext.save()
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggleSong(_ song: Song) {
        if setlist.songs?.contains(song) == true {
            setlist.removeFromSongs(song)
        } else {
            setlist.addToSongs(song)
        }
    }
}

struct SongPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext

        // Create a setlist and song in preview context
        let setlist = Setlist(context: context)
        setlist.name = "Worship Night"

        let song = Song(context: context)
        song.title = "10,000 Reasons"
        song.artist = "Matt Redman"
        context.insert(song)

        return SongPickerView(setlist: setlist)
            .environment(\.managedObjectContext, context)
    }
}
