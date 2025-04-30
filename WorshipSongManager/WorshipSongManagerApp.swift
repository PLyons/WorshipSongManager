//
//  WorshipSongManagerApp.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//

import SwiftUI

@main
struct WorshipSongManagerApp: App {
    // Use the shared instance of the persistence controller
    let persistenceController = PersistenceController.shared
    
    init() {
        // Register secure transformers
        // Register secure transformers
        ValueTransformerRegistration.registerTransformers()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
