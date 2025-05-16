//
//  WorshipSongManagerApp.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//  Modified by Architect on 5/15/25.
//

import SwiftUI

@main
struct WorshipSongManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SongListView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
