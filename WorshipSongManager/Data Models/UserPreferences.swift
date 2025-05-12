//
//  UserPreferences.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    var id: UUID
    var chordNotation: String     // e.g., Nashville, standard, jazz
    var prefersDarkMode: Bool
    var defaultCapo: Int

    init(
        id: UUID = UUID(),
        chordNotation: String = "standard",
        prefersDarkMode: Bool = false,
        defaultCapo: Int = 0
    ) {
        self.id = id
        self.chordNotation = chordNotation
        self.prefersDarkMode = prefersDarkMode
        self.defaultCapo = defaultCapo
    }
}

