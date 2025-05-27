//
//  WorshipSongManagerApp.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-04-29
//  Modified by Paul Lyons on 2025-05-27
//

import SwiftUI

@main
struct WorshipSongManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
