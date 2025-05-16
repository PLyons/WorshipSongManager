//
//  SongListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/10/25.
//  Modified by Architect on 5/15/25.
//

import SwiftUI
import CoreData

struct SongListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: SongListViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: SongListViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredSongs) { song in
                    NavigationLink {
                        SongDetailView(viewModel: SongDetailViewModel(song: song, context: context))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(song.title ?? "Untitled")
                                    .font(.headline)
                                Text(song.artist ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if song.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: viewModel.deleteSongs)
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Songs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showAddSongSheet = true }) {
                        Label("Add Song", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSongSheet) {
                AddSongView()
                    .environment(\.managedObjectContext, context)
            }
        }
        .onAppear {
            viewModel.fetchSongs()
        }
    }
}



struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        SongListView(context: context)
            .environment(\.managedObjectContext, context)
    }
}



