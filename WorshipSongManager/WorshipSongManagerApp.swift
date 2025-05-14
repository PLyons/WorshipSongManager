//
//  WorshipSongManagerApp.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//  Modified by Paul Lyons on 5/13/25.
//

import SwiftUI

@main
struct WorshipSongManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
