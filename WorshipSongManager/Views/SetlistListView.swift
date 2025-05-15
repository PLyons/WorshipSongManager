//
//  SetlistListView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/15/25.
//  Modified by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct SetlistListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Setlist.dateCreated, ascending: false)],
        animation: .default)
    private var setlists: FetchedResults<Setlist>

    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(setlists) { setlist in
                    NavigationLink(destination: SetlistDetailView(setlist: setlist)) {
                        VStack(alignment: .leading) {
                            Text(setlist.name ?? "Untitled Setlist")
                                .font(.headline)
                            if let date = setlist.date {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Setlists")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSheet = true }) {
                        Label("New Setlist", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSetlistView()
            }
        }
    }
}

struct SetlistListView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistListView()
            .environment(\.managedObjectContext, PreviewPersistenceController.shared.viewContext)
    }
}
