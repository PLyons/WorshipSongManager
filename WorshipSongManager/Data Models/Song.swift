//
//  Song.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@Model
class Song {
    var title: String
    var artist: String
    var key: String
    var tempo: Int
    var timeSignature: String
    var copyright: String
    var content: String
    var isFavorite: Bool
    var dateCreated: Date
    var dateModified: Date

    // Relationships
    var setlistItems: [SetlistItem]?
    var chordCharts: [ChordChart]?

    init(title: String = "",
         artist: String = "",
         key: String = "",
         tempo: Int = 0,
         timeSignature: String = "",
         copyright: String = "",
         content: String = "",
         isFavorite: Bool = false,
         dateCreated: Date = .now,
         dateModified: Date = .now) {
        self.title = title
        self.artist = artist
        self.key = key
        self.tempo = tempo
        self.timeSignature = timeSignature
        self.copyright = copyright
        self.content = content
        self.isFavorite = isFavorite
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}
