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
    @ObservedObject var setlist: Setlist

    var body: some View {
        VStack {
            Text(setlist.name ?? "Untitled")
                .font(.largeTitle)
                .padding()

            if let notes = setlist.notes {
                Text(notes).padding()
            }

            Text("Songs will be shown here")
                .foregroundStyle(.secondary)
                .padding()
        }
        .navigationTitle("Setlist")
    }
}

struct SetlistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        let setlist = Setlist(context: context)
        setlist.name = "Sample Setlist"
        setlist.date = Date()
        setlist.dateCreated = Date()
        return NavigationView {
            SetlistDetailView(setlist: setlist)
        }
    }
}
