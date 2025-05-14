//
//  SongFormView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import CoreData

struct SongFormView: View {
    @ObservedObject var song: Song

    var body: some View {
        Form {
            Section(header: Text("Song Details")) {
                TextField("Title", text: binding(for: \.title))
                TextField("Artist", text: binding(for: \.artist))
                TextField("Key", text: binding(for: \.key))
                TextField("Tempo", value: bindingInt(for: \.tempo), formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                TextField("Time Signature", text: binding(for: \.timeSignature))
                TextField("Copyright", text: binding(for: \.copyright))
                Toggle("Favorite", isOn: bindingBool(for: \.isFavorite))
            }

            Section(header: Text("Lyrics and Chords")) {
                TextEditor(text: binding(for: \.content))
                    .frame(minHeight: 200)
            }
        }
    }

    private func binding(for keyPath: ReferenceWritableKeyPath<Song, String?>) -> Binding<String> {
        Binding(
            get: { song[keyPath: keyPath] ?? "" },
            set: { song[keyPath: keyPath] = $0 }
        )
    }

    private func bindingInt(for keyPath: ReferenceWritableKeyPath<Song, Int16>) -> Binding<Int> {
        Binding(
            get: { Int(song[keyPath: keyPath]) },
            set: { song[keyPath: keyPath] = Int16($0) }
        )
    }

    private func bindingBool(for keyPath: ReferenceWritableKeyPath<Song, Bool>) -> Binding<Bool> {
        Binding(
            get: { song[keyPath: keyPath] },
            set: { song[keyPath: keyPath] = $0 }
        )
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sample = Song(context: context)
    sample.title = "Preview Title"
    sample.artist = "Preview Artist"
    sample.key = "C"
    sample.tempo = 100
    sample.timeSignature = "4/4"
    sample.copyright = "Public Domain"
    sample.content = "Sample lyrics or chords"
    sample.isFavorite = true
    sample.dateCreated = Date()
    sample.dateModified = Date()

    return SongFormView(song: sample)
}
