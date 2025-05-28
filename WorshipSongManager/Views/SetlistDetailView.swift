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
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: SetlistDetailViewModel
    
    init(setlist: Setlist) {
        // Create the view model with the shared persistence controller context
        // This ensures we're using the same context throughout the app
        let viewContext = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: SetlistDetailViewModel(setlist: setlist, context: viewContext))
    }

    var body: some View {
        Group {
            if viewModel.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                songListView
            }
        }
        .navigationTitle(viewModel.setlistName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !viewModel.isEmpty {
                    Button(viewModel.isEditing ? "Done" : "Edit") {
                        viewModel.toggleEditMode()
                    }
                }
                
                Button {
                    viewModel.showingSongPicker = true
                } label: {
                    Label("Add Songs", systemImage: "plus")
                }
                .disabled(viewModel.isLoading)
            }
        }
        .sheet(isPresented: $viewModel.showingSongPicker) {
            viewModel.refreshSongs()
        } content: {
            SongPickerView(setlist: viewModel.setlist)
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .overlay {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
    
    // MARK: - View Components
    
    private var songListView: some View {
        List {
            setlistInfoSection
            songsSection
        }
    }
    
    private var setlistInfoSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.songCountText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Performance time estimate (future feature)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Est. Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("25 min")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var songsSection: some View {
        Section(header: Text("Songs")) {
            ForEach(viewModel.songs, id: \.objectID) { song in
                NavigationLink(destination: SongDetailView(viewModel: SongDetailViewModel(song: song, context: context))) {
                    SetlistSongRowView(song: song, isEditing: viewModel.isEditing)
                }
                .disabled(viewModel.isEditing) // Disable navigation during editing
            }
            .onDelete { offsets in
                Task {
                    await viewModel.removeSongs(at: offsets)
                }
            }
            .onMove(perform: viewModel.isEditing ? viewModel.reorderSongs : { _, _ in /* Do nothing */ }) // <--- MODIFIED LINE TO REMOVE COMPILER ERROR
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "music.note.list")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Songs in Setlist")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Add songs to \(viewModel.setlistName) to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Add Songs") {
                viewModel.showingSongPicker = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }
}

// MARK: - Supporting Views

struct SetlistSongRowView: View {
    let song: Song
    let isEditing: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title ?? "Untitled")
                    .font(.headline)
                
                HStack {
                    if let artist = song.artist, !artist.isEmpty {
                        Text(artist)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Song metadata badges
                    HStack(spacing: 8) {
                        if let key = song.key, !key.isEmpty {
                            SetlistMetadataBadge(text: key, color: .blue)
                        }
                        
                        if song.tempo > 0 {
                            SetlistMetadataBadge(text: "\(song.tempo)", color: .green)
                        }
                    }
                }
            }
            
            if isEditing {
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct SetlistMetadataBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Updating Setlist...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(radius: 10)
            )
        }
    }
}

// MARK: - Preview

struct SetlistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        
        let setlist = Setlist(context: context)
        setlist.name = "Sunday Morning Worship"
        setlist.date = Date()
        setlist.dateCreated = Date()
        
        let song = Song(context: context)
        song.title = "Amazing Grace"
        song.artist = "John Newton"
        song.key = "G"
        song.tempo = 90
        
        setlist.addToSongs(song)
        
        return NavigationView {
            SetlistDetailView(setlist: setlist)
        }
        .environment(\.managedObjectContext, context)
    }
}
