//
//  AddSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import SwiftUI
import SwiftData

struct AddSongView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var artist = ""
    @State private var key = ""
    @State private var tempo: String = ""
    @State private var timeSignature = "4/4"
    @State private var copyright = ""
    @State private var content: String = ""
    @State private var isFavorite: Bool = false

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
                    .disabled(title.isEmpty || key.isEmpty)
                }
            }
        }
    }

    private func addSong() {
        let tempoValue = Int(tempo) ?? 120
        let song = Song(
            title: title,
            artist: artist,
            key: key,
            tempo: tempoValue,
            timeSignature: timeSignature,
            copyright: copyright,
            content: content,
            isFavorite: isFavorite
        )
        
        modelContext.insert(song)
        try? modelContext.save()
        dismiss()
    }

}
