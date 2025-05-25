//
//  SongFormView.swift
//  WorshipSongManager
//
//  Created by Developer on 2025-05-25
//

import SwiftUI
import CoreData

struct SongFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SongFormViewModel
    
    // Key picker options
    private let musicalKeys = [
        "", // Empty option for "no selection"
        "C", "C#", "Db", "D", "D#", "Eb", "E", "F",
        "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                songDetailsSection
                lyricsAndChordsSection
                
                if !viewModel.validationErrors.isEmpty {
                    validationErrorsSection
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancel()
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.saveButtonTitle) {
                        Task {
                            if await viewModel.save() {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: $viewModel.showingErrorAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .overlay {
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var songDetailsSection: some View {
        Section(header: Text("Song Details")) {
            TextField("Title", text: $viewModel.title)
                .onChange(of: viewModel.title) { oldValue, newValue in
                    viewModel.validateField(.title)
                }
            
            TextField("Artist", text: $viewModel.artist)
                .onChange(of: viewModel.artist) { oldValue, newValue in
                    viewModel.validateField(.artist)
                }
            
            // Simple Key Picker Row
            HStack {
                Text("Key")
                
                Spacer()
                
                if viewModel.key.isEmpty {
                    // Show picker when no key selected
                    Picker("", selection: $viewModel.key) {
                        Text("Choose Key").tag("")
                        
                        ForEach(musicalKeys.dropFirst(), id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: viewModel.key) { oldValue, newValue in
                        viewModel.validateField(.key)
                    }
                } else {
                    // Show selected key badge with option to change it
                    HStack(spacing: 8) {
                        Text(viewModel.key)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 32, minHeight: 32)
                            .background(
                                Circle()
                                    .fill(keyColor(for: viewModel.key))
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            )
                        
                        Picker("", selection: $viewModel.key) {
                            Text("Change Key").tag("")
                            
                            ForEach(musicalKeys.dropFirst(), id: \.self) { key in
                                Text(key).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewModel.key) { oldValue, newValue in
                            viewModel.validateField(.key)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Tempo (BPM)", text: $viewModel.tempo)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.tempo) { oldValue, newValue in
                        viewModel.validateField(.tempo)
                    }
                
                if !viewModel.tempo.isEmpty, let bpm = Int(viewModel.tempo) {
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(bpm) BPM")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(tempoDescription(for: bpm))
                            .font(.caption2)
                            .foregroundColor(tempoColor(for: bpm))
                            .fontWeight(.medium)
                    }
                }
            }
            
            TextField("Time Signature", text: $viewModel.timeSignature)
            
            TextField("Copyright", text: $viewModel.copyright)
            
            Toggle("Favorite", isOn: $viewModel.isFavorite)
        }
    }
    
    private var lyricsAndChordsSection: some View {
        Section(header: Text("Lyrics and Chords")) {
            TextEditor(text: $viewModel.content)
                .frame(minHeight: 200)
        }
    }
    
    private var validationErrorsSection: some View {
        Section {
            ForEach(viewModel.validationErrors, id: \.self) { error in
                Label(error, systemImage: "exclamationmark.triangle")
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
        } header: {
            Label("Required Fields", systemImage: "exclamationmark.triangle")
                .foregroundColor(.red)
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("Saving Song...")
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
    
    // MARK: - Helper Methods
    
    private func tempoDescription(for bpm: Int) -> String {
        switch bpm {
        case 0..<60:
            return "Very Slow"
        case 60..<80:
            return "Slow"
        case 80..<100:
            return "Moderate"
        case 100..<120:
            return "Medium"
        case 120..<140:
            return "Upbeat"
        case 140..<160:
            return "Fast"
        case 160..<180:
            return "Very Fast"
        default:
            return "Extremely Fast"
        }
    }
    
    private func tempoColor(for bpm: Int) -> Color {
        switch bpm {
        case 0..<80:
            return .blue
        case 80..<120:
            return .green
        case 120..<160:
            return .orange
        default:
            return .red
        }
    }
    
    private func keyColor(for key: String) -> Color {
        // Color-code keys for easy recognition
        switch key {
        // Natural keys - blue tones
        case "C": return .blue
        case "D": return .indigo
        case "E": return .purple
        case "F": return .green
        case "G": return .mint
        case "A": return .teal
        case "B": return .cyan
        
        // Sharp keys - orange/yellow tones
        case "C#", "D#", "F#", "G#", "A#": return .orange
        
        // Flat keys - red/pink tones
        case "Db", "Eb", "Gb", "Ab", "Bb": return .pink
        
        default: return .gray
        }
    }
}

// MARK: - Preview

#Preview("Add Song") {
    let context = PreviewPersistenceController.shared.viewContext
    return SongFormView(
        viewModel: SongFormViewModel(
            context: context,
            mode: .add
        )
    )
}

#Preview("Edit Song") {
    let context = PreviewPersistenceController.shared.viewContext
    
    // Create and configure preview song
    let song = Song(context: context)
    song.title = "Amazing Grace"
    song.artist = "John Newton"
    song.key = "G"
    song.tempo = 90
    song.timeSignature = "4/4"
    song.content = "Amazing grace, how sweet the sound\nThat saved a wretch like me"
    song.dateCreated = Date()
    song.dateModified = Date()
    
    // Save to context to avoid validation issues
    try? context.save()
    
    return SongFormView(
        viewModel: SongFormViewModel(
            context: context,
            mode: .edit(song)
        )
    )
}
