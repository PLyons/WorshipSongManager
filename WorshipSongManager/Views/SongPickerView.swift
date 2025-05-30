///
//  SongPickerView.swift
//  WorshipSongManager
//
//  Created by Architect on 05/15/25
//  Updated by Paul Lyons on 2025-05-28
//

import SwiftUI
import CoreData

struct SongPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SongPickerViewModel
    
    // MARK: - Initialization
    init(setlist: Setlist, context: NSManagedObjectContext) {
        self._viewModel = StateObject(wrappedValue: SongPickerViewModel(setlist: setlist, context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchSection
                
                // Content
                if viewModel.isLoading {
                    loadingSection
                } else if viewModel.filteredSongs.isEmpty {
                    emptyStateSection
                } else {
                    songsListSection
                }
                
                Spacer()
                
                // Action buttons
                actionButtonsSection
            }
            .navigationTitle("Add Songs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.filteredSongs.isEmpty {
                        Button(viewModel.selectAllButtonTitle) {
                            viewModel.selectAllVisibleSongs()
                        }
                        .font(.subheadline)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showingErrorAlert) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }
    
    // MARK: - View Components
    private var searchSection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search songs...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled(true)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            
            Divider()
        }
    }
    
    private var loadingSection: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading songs...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(viewModel.searchText.isEmpty ? "No Available Songs" : "No Results")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(viewModel.searchText.isEmpty ?
                     "All songs are already in this setlist or no songs have been created yet." :
                     "No songs match your search criteria.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var songsListSection: some View {
        List {
            ForEach(viewModel.filteredSongs, id: \.objectID) { song in
                SongPickerRowView(
                    song: song,
                    isSelected: viewModel.isSelected(song),
                    onToggle: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.toggleSong(song)
                        }
                    }
                )
            }
        }
        .listStyle(.plain)
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button(action: {
                    Task {
                        let success = await viewModel.saveSelectedSongs()
                        if success {
                            dismiss()
                        }
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(viewModel.saveButtonTitle)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!viewModel.hasSelectedSongs || viewModel.isLoading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Song Picker Row View
struct SongPickerRowView: View {
    let song: Song
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                // Song information
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title ?? "Untitled Song")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if let artist = song.artist, !artist.isEmpty {
                        Text(artist)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Song metadata badges
                HStack(spacing: 8) {
                    if let key = song.key, !key.isEmpty {
                        Text(key)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(keyColor(for: key))
                            )
                    }
                    
                    if song.tempo > 0 {
                        Text("\(song.tempo) BPM")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray5))
                            )
                    }
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func keyColor(for key: String) -> Color {
        // Simple color mapping for keys
        switch key.uppercased() {
        case "C": return .blue
        case "C#", "DB": return .indigo
        case "D": return .purple
        case "D#", "EB": return .pink
        case "E": return .red
        case "F": return .orange
        case "F#", "GB": return .yellow
        case "G": return .green
        case "G#", "AB": return .mint
        case "A": return .teal
        case "A#", "BB": return .cyan
        case "B": return .blue
        default: return .gray
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? Color.accentColor.opacity(0.8) : Color.accentColor)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.accentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(configuration.isPressed ? Color.accentColor.opacity(0.1) : Color.clear)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
