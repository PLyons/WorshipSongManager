//
//  SetlistListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-15
//  Modified by Paul Lyons on 2025-05-27
//

import SwiftUI
import CoreData

struct SetlistListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: SetlistListViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: SetlistListViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.setlists.isEmpty {
                    loadingView
                } else if viewModel.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    setlistsList
                }
            }
            .navigationTitle("Setlists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingAddSheet = true }) {
                        Label("New Setlist", systemImage: "plus")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                viewModel.refreshSetlists()
            } content: {
                AddSetlistSheet(viewModel: viewModel)
            }
            .alert("Error", isPresented: $viewModel.showingErrorAlert) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .refreshable {
                await viewModel.fetchSetlists()
            }
        }
        .task {
            await viewModel.fetchSetlists()
        }
    }
    
    // MARK: - View Components
    
    private var setlistsList: some View {
        List {
            ForEach(viewModel.filteredSetlists) { setlist in
                NavigationLink(destination: SetlistDetailView(setlist: setlist)) {
                    SetlistRowView(setlist: setlist)
                }
            }
            .onDelete(perform: deleteSetlists)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search setlists...")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading Setlists...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "music.note.list")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Setlists Yet")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Create your first setlist to organize songs for worship services")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Create Setlist") {
                viewModel.showingAddSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }
    
    // MARK: - Actions
    
    private func deleteSetlists(at offsets: IndexSet) {
        Task {
            await viewModel.deleteSetlists(at: offsets)
        }
    }
}

// MARK: - Supporting Views

struct SetlistRowView: View {
    let setlist: Setlist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(setlist.name ?? "Untitled Setlist")
                .font(.headline)
            
            HStack {
                if let date = setlist.date {
                    Label(date.formatted(date: .abbreviated, time: .omitted),
                          systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Song count
                if let songsCount = setlist.songs?.count, songsCount > 0 {
                    Label("\(songsCount) song\(songsCount == 1 ? "" : "s")",
                          systemImage: "music.note")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddSetlistSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SetlistListViewModel
    
    @State private var name = ""
    @State private var date = Date()
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Setlist Details")) {
                    TextField("Setlist Name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Setlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isCreating)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            isCreating = true
                            if await viewModel.createNewSetlist(name: name, date: date) {
                                dismiss()
                            }
                            isCreating = false
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || isCreating)
                }
            }
            .overlay {
                if isCreating {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView("Creating Setlist...")
                                .padding()
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                }
            }
        }
    }
}

// MARK: - Preview

struct SetlistListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        SetlistListView(context: context)
            .environment(\.managedObjectContext, context)
    }
}
