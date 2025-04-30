//
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import SwiftUI

struct SongDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var song: Song
    @State private var isEditing = false
    
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
                }
                .padding(.bottom)
                
                // Content section
                if let content = song.content, !content.isEmpty {
                    Text("Lyrics:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(content)
                        .font(.body)
                        .lineSpacing(8)
                } else {
                    Text("No lyrics added")
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Song Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing = true }) {
                    Text("Edit")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFavorite) {
                    Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditSongView(song: song)
        }
    }
    
    private func toggleFavorite() {
        song.isFavorite.toggle()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error toggling favorite: \(nsError), \(nsError.userInfo)")
        }
    }
}
