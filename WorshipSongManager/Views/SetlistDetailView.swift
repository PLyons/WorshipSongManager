//
//  SetlistDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/15/25.
//  Modified by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct SetlistDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var setlist: Setlist
    @State private var showingSongPicker = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(setlist.name ?? "Untitled Setlist")
                .font(.largeTitle)
                .padding(.bottom)

            if let notes = setlist.notes {
                Text(notes).padding(.bottom)
            }

            List {
                Section(header: Text("Songs in Setlist")) {
                    ForEach(setlist.songsArray, id: \.self) { song in
                        VStack(alignment: .leading) {
                            Text(song.title ?? "Untitled")
                                .font(.headline)
                            if let artist = song.artist {
                                Text(artist).font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: removeSongs)
                }
            }

            Spacer()
        }
        .navigationTitle("Setlist")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingSongPicker = true
                } label: {
                    Label("Add Song", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingSongPicker) {
            SongPickerView(setlist: setlist)
                .environment(\.managedObjectContext, viewContext)
        }
    }

    private func removeSongs(at offsets: IndexSet) {
        for index in offsets {
            let song = setlist.songsArray[index]
            setlist.removeFromSongs(song)
        }
        try? viewContext.save()
    }
}

private extension Setlist {
    var songsArray: [Song] {
        let set = songs as? Set<Song> ?? []
        return set.sorted { ($0.title ?? "") < ($1.title ?? "") }
    }
}

struct SetlistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext

        // Mock Setlist and Songs
        let setlist = Setlist(context: context)
        setlist.name = "Sample Setlist"
        setlist.dateCreated = Date()

        let song = Song(context: context)
        song.title = "Amazing Grace"
        song.artist = "John Newton"
        setlist.addToSongs(song)

        return NavigationView {
            SetlistDetailView(setlist: setlist)
        }
        .environment(\.managedObjectContext, context)
    }
}
