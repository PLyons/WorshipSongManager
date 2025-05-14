//
//  ContentView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SongListView()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
