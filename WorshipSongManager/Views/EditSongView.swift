//
//  EditSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/15/25.
//  Modified by Paul Lyons on 05/15/25
//

import SwiftUI
import CoreData

struct EditSongView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var song: Song

    @State private var title: String
    @State private var artist: String
    @State private var key: String
    @State private var tempo: String
    @State private var timeSignature: String
    @State private var copyright: String
    @State private var content: String
    @State private var isFavorite: Bool

    init(song: Song) {
        self.song = song
        _title = State(initialValue: song.title ?? "")
        _artist = State(initialValue: song.artist ?? "")
        _key = State(initialValue: song.key ?? "")
        _tempo = State(initialValue: String(song.tempo))
        _timeSignature = State(initialValue: song.timeSignature ?? "")
        _copyright = State(initialValue: song.copyright ?? "")
        _content = State(initialValue: song.content ?? "")
        _isFavorite = State(initialValue: song.isFavorite)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Key", text: $key)
                    TextField("Tempo", text: $tempo)
                        .keyboardType(.numberPad)
                    TextField("Time Signature", text: $timeSignature)
                    TextField("Copyright", text: $copyright)
                    Toggle("Favorite", isOn: $isFavorite)
                }

                Section(header: Text("Lyrics or Chord Chart")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("Edit Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        song.title = title
                        song.artist = artist
                        song.key = key
                        song.tempo = Int16(tempo) ?? 0
                        song.timeSignature = timeSignature
                        song.copyright = copyright
                        song.content = content
                        song.isFavorite = isFavorite
                        song.dateModified = Date()
                        try? viewContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditSongView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        let song = Song(context: context)
        song.title = "Preview Song"
        song.artist = "Preview Artist"
        song.key = "G"
        song.tempo = 90
        song.timeSignature = "4/4"
        song.content = "Lyrics here"
        return EditSongView(song: song)
            .environment(\.managedObjectContext, context)
    }
}
