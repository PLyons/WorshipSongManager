//
//  SongFormView.swift
//  WorshipSongManager
//
//  Created by Developer on 2025-05-25
//

import SwiftUI

struct SongFormView: View {
    @ObservedObject var viewModel: SongFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    let musicalKeys = ["", "C", "C#", "Db", "D", "D#", "Eb", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"]
    
    var body: some View {
        NavigationView {
            Form {
                songDetailsSection
                lyricsAndChordsSection
                validationErrorsSection
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.saveButtonTitle) {
                        Task {
                            if await viewModel.save() {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading) // Remove isValid check for better UX
                }
            }
            .alert("Error", isPresented: $viewModel.showingErrorAlert) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView("Saving...")
                                .padding()
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                }
            }
        }
    }
    
    private var songDetailsSection: some View {
        Section("SONG DETAILS") {
            // Title Field - REMOVED .onChange validation
            HStack {
                Text("Title")
                Spacer()
                TextField("Song Title", text: $viewModel.title)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .multilineTextAlignment(.trailing)
                    // REMOVED: .onChange validation for better UX
            }
            
            // Artist Field - REMOVED .onChange validation
            HStack {
                Text("Artist")
                Spacer()
                TextField("Artist", text: $viewModel.artist)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .multilineTextAlignment(.trailing)
                    // REMOVED: .onChange validation for better UX
            }
            
            // Key Field - REMOVED .onChange validation
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
                    // REMOVED: .onChange validation for better UX
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
                        // REMOVED: .onChange validation for better UX
                    }
                }
            }
            
            // Tempo Field - REMOVED .onChange validation
            HStack {
                Text("Tempo")
                
                TextField("Tempo (BPM)", text: $viewModel.tempo)
                    .autocorrectionDisabled(true)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    // REMOVED: .onChange validation for better UX
                
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
            
            // Copyright Field
            HStack {
                Text("Public Domain")
                Spacer()
                Toggle("", isOn: $viewModel.isPublicDomain)
                    .onChange(of: viewModel.isPublicDomain) { _, newValue in
                        if newValue {
                            viewModel.copyright = ""
                        }
                    }
            }
            
            if !viewModel.isPublicDomain {
                HStack {
                    Text("Copyright")
                    Spacer()
                    TextField("Copyright Info", text: $viewModel.copyright)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            // Favorite Field
            HStack {
                Text("Favorite")
                Spacer()
                Toggle("", isOn: $viewModel.isFavorite)
            }
        }
    }
    
    private var lyricsAndChordsSection: some View {
        Section("LYRICS AND CHORDS") {
            TextEditor(text: $viewModel.content)
                .autocorrectionDisabled(true)
                .frame(minHeight: 200)
                .font(.system(.body, design: .monospaced))
                // REMOVED: .onChange validation for better UX
        }
    }
    
    private var validationErrorsSection: some View {
        Group {
            if !viewModel.validationErrors.isEmpty {
                Section {
                    ForEach(viewModel.validationErrors, id: \.self) { error in
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                } header: {
                    Text("REQUIRED FIELDS")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func keyColor(for key: String) -> Color {
        let sharpKeys = ["C#", "D#", "F#", "G#", "A#"]
        let flatKeys = ["Db", "Eb", "Gb", "Ab", "Bb"]
        
        if sharpKeys.contains(key) {
            return .indigo
        } else if flatKeys.contains(key) {
            return .purple
        } else {
            return .blue
        }
    }
    
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
            return "Fast"
        case 140..<180:
            return "Very Fast"
        default:
            return "Extremely Fast"
        }
    }
    
    private func tempoColor(for bpm: Int) -> Color {
        switch bpm {
        case 0..<60:
            return .blue
        case 60..<80:
            return .green
        case 80..<100:
            return .yellow
        case 100..<120:
            return .orange
        case 120..<140:
            return .red
        case 140..<180:
            return .purple
        default:
            return .pink
        }
    }
}

// MARK: - Preview

#Preview {
    SongFormView(
        viewModel: SongFormViewModel(
            context: PersistenceController.shared.container.viewContext,
            mode: .add
        )
    )
}
