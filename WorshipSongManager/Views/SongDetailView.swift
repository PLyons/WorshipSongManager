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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and artist section
                VStack(alignment: .leading, spacing: 8) {
                    if viewModel.isEditing {
                        TextField("Title", text: $viewModel.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TextField("Artist", text: $viewModel.artist)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    } else {
                        Text(viewModel.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        if !viewModel.artist.isEmpty {
                            Text(viewModel.artist)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }

                    if !viewModel.key.isEmpty {
                        Text("Key: \(viewModel.key)")
                            .font(.headline)
                    }

                    if !viewModel.tempo.isEmpty {
                        Text("Tempo: \(viewModel.tempo) bpm")
                            .font(.headline)
                    }

                    if !viewModel.timeSignature.isEmpty {
                        Text("Time Signature: \(viewModel.timeSignature)")
                            .font(.headline)
                    }
                }

                Divider()

                if viewModel.isEditing {
                    TextEditor(text: $viewModel.content)
                        .frame(minHeight: 200)
                } else {
                    Text(viewModel.content)
                        .font(.body)
                        .lineSpacing(6)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.isEditing ? "Edit Song" : "Song Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isEditing {
                    Button("Save") {
                        if viewModel.saveChanges() {
                            viewModel.isEditing = false
                        }
                    }
                } else {
                    Button("Edit") {
                        viewModel.isEditing = true
                    }
                }
            }

            if viewModel.isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.cancelChanges()
                        viewModel.isEditing = false
                    }
                }
            }
        }
        .alert(isPresented: .constant(viewModel.validationMessage != nil)) {
            Alert(
                title: Text("Validation Error"),
                message: Text(viewModel.validationMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    let context = PreviewPersistenceController.shared.viewContext
    let request = NSFetchRequest<Song>(entityName: "Song")
    request.fetchLimit = 1
    let song = (try? context.fetch(request).first) ?? Song(context: context)
    let viewModel = SongDetailViewModel(song: song, context: context)
    return NavigationView {
        SongDetailView(viewModel: viewModel)
    }
}
