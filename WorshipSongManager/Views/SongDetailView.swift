//
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI
import CoreData

struct SongDetailView: View {
    @ObservedObject var song: Song

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and artist section
                VStack(alignment: .leading, spacing: 8) {
                    Text(song.title ?? "Untitled")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if let artist = song.artist, !artist.isEmpty {
                        Text(artist)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }

                    if let key = song.key, !key.isEmpty {
                        Text("Key: \(key)")
                            .font(.headline)
                    }

                    if let tempo = song.tempo as Int16?, tempo > 0 {
                        Text("Tempo: \(tempo) BPM")
                            .font(.subheadline)
                    }

                    if let timeSig = song.timeSignature, !timeSig.isEmpty {
                        Text("Time Signature: \(timeSig)")
                            .font(.subheadline)
                    }
                }

                // Content section
                if let content = song.content, !content.isEmpty {
                    Text("Lyrics and Chords")
                        .font(.headline)
                        .padding(.bottom, 4)

                    Text(content)
                        .font(.body)
                        .lineSpacing(6)
                }

                // Optional copyright section
                if let copyright = song.copyright, !copyright.isEmpty {
                    Text("© \(copyright)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Song Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let previewSong = Song(context: context)
    previewSong.title = "What a Beautiful Name"
    previewSong.artist = "Hillsong Worship"
    previewSong.key = "D"
    previewSong.tempo = 72
    previewSong.timeSignature = "6/8"
    previewSong.content = """
    [D] What a beautiful name it is
    The name of [A] Jesus Christ my [Bm] King
    """
    previewSong.copyright = "Capitol CMG Publishing"
    previewSong.dateCreated = Date()
    previewSong.dateModified = Date()
    previewSong.isFavorite = false

    return NavigationView {
        SongDetailView(song: previewSong)
    }
    .environment(\.managedObjectContext, context)
}
