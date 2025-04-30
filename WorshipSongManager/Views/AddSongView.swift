//
//  AddSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import SwiftUI

struct AddSongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var artist = ""
    @State private var content = ""
    @State private var key = ""
    @State private var isFavorite = false
    
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
            .navigationTitle("Add Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addSong()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addSong() {
        withAnimation {
            let newSong = Song(context: viewContext)
            newSong.id = UUID()
            newSong.title = title
            newSong.artist = artist
            newSong.content = content
            newSong.key = key
            newSong.isFavorite = isFavorite
            newSong.dateCreated = Date()
            newSong.dateModified = Date()
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                print("Error adding song: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
