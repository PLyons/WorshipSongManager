//
//  EditSongView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import CoreData

struct EditSongView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var song: Song

    var body: some View {
        NavigationView {
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
                        saveEdits()
                    }
                }
            }
        }
    }

    private func saveEdits() {
        song.dateModified = Date()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("❌ Failed to save edits: \(error.localizedDescription)")
        }
    }

    // MARK: - Binding helpers

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
    let previewSong = Song(context: context)
    previewSong.title = "Edit Me"
    previewSong.artist = "Preview Artist"
    previewSong.key = "C"
    previewSong.tempo = 100
    previewSong.timeSignature = "4/4"
    previewSong.copyright = "© 2025"
    previewSong.content = "Some lyrics or chords"
    previewSong.isFavorite = true
    previewSong.dateCreated = Date()
    previewSong.dateModified = Date()

    return EditSongView(song: previewSong)
        .environment(\.managedObjectContext, context)
}
