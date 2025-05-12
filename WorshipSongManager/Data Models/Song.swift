//
//  Song.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//

import Foundation
import SwiftData

@Model
class Song {
    var id: UUID
    var title: String
    var artist: String
    var key: String
    var tempo: Int
    var timeSignature: String
    var copyright: String
    var content: String            // Lyrics or chord chart
    var isFavorite: Bool           // For favoriting songs
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
        self.id = UUID()
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

