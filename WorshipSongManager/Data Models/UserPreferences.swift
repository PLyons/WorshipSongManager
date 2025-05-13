//
//  UserPreferences.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    var chordNotation: String     // e.g., Nashville, standard, jazz
    var prefersDarkMode: Bool
    var defaultCapo: Int

    init(
        chordNotation: String = "standard",
        prefersDarkMode: Bool = false,
        defaultCapo: Int = 0
    ) {
        self.chordNotation = chordNotation
        self.prefersDarkMode = prefersDarkMode
        self.defaultCapo = defaultCapo
    }
}
