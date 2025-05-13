//
//  PreviewHelpers.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@MainActor
func previewModelContainer() -> ModelContainer {
    do {
        return try ModelContainer(
            for: Song.self,  // Only Song is loaded to avoid preview crash
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    } catch {
        fatalError("⚠️ Failed to create preview model container: \(error)")
    }
}
