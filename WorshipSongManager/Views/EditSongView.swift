//
//  EditSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import SwiftUI

struct EditSongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var song: Song
    
    @State private var title: String
    @State private var artist: String
    @State private var content: String
    @State private var key: String
    @State private var isFavorite: Bool
    
    init(song: Song) {
        self.song = song
        _title = State(initialValue: song.title ?? "")
        _artist = State(initialValue: song.artist ?? "")
        _content = State(initialValue: song.content ?? "")
        _key = State(initialValue: song.key ?? "")
        _isFavorite = State(initialValue: song.isFavorite)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Key", text: $key)
                    Toggle("Favorite", isOn: $isFavorite)
                }
                
                Section(header: Text("Lyrics")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("Edit Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateSong()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func updateSong() {
        withAnimation {
            song.title = title
            song.artist = artist
            song.content = content
            song.key = key
            song.isFavorite = isFavorite
            song.dateModified = Date()
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                print("Error updating song: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
