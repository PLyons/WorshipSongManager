//
//  WorshipSongManagerApp.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//

import SwiftUI
import SwiftData

@main
struct WorshipSongManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Song.self,
            Setlist.self,
            SetlistItem.self,
            ChordChart.self,
            UserPreferences.self
        ])
    }
}
