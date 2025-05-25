///
//  SongDetailView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Architect on 5/15/25.
//

import SwiftUI
import CoreData

struct SongDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var viewModel: SongDetailViewModel
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and artist section
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if !viewModel.artist.isEmpty {
                        Text(viewModel.artist)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }

                    // Song metadata with enhanced styling
                    HStack(spacing: 16) {
                        if !viewModel.key.isEmpty {
                            MetadataTag(label: "Key", value: viewModel.key, color: .blue)
                        }

                        if !viewModel.tempo.isEmpty, let bpm = Int(viewModel.tempo), bpm > 0 {
                            MetadataTag(label: "Tempo", value: "\(bpm) BPM", color: .green)
                        }

                        if !viewModel.timeSignature.isEmpty {
                            MetadataTag(label: "Time", value: viewModel.timeSignature, color: .orange)
                        }
                    }
                }

                Divider()

                Text(viewModel.content)
                    .font(.body)
                    .lineSpacing(6)
            }
            .padding()
        }
        .navigationTitle("Song Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            SongFormView(
                viewModel: SongFormViewModel(
                    context: context,
                    mode: .edit(viewModel.song)
                )
            )
        }
    }
}

// MARK: - Supporting Views

struct MetadataTag: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                )
        }
    }
}

#Preview {
    let context = PreviewPersistenceController.shared.viewContext
    let song = Song(context: context)
    song.title = "Amazing Grace"
    song.artist = "John Newton"
    song.key = "G"
    song.tempo = 90
    song.timeSignature = "4/4"
    song.content = "Amazing grace, how sweet the sound"
    
    let viewModel = SongDetailViewModel(song: song, context: context)
    return NavigationView {
        SongDetailView(viewModel: viewModel)
    }
}
