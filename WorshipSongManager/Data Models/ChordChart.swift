//
//  ChordChart.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@Model
class ChordChart {
    var rawText: String
    var key: String
    var capo: Int
    var dateCreated: Date
    var dateModified: Date

    // Relationship
    var song: Song

    init(
        rawText: String,
        key: String,
        capo: Int = 0,
        song: Song,
        dateCreated: Date = .now,
        dateModified: Date = .now
    ) {
        self.rawText = rawText
        self.key = key
        self.capo = capo
        self.song = song
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}
