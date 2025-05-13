//
//  SetlistItem.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@Model
class SetlistItem {
    var position: Int
    var dateCreated: Date
    var dateModified: Date

    // Relationships
    var song: Song
    var setlist: Setlist

    init(
        position: Int,
        song: Song,
        setlist: Setlist,
        dateCreated: Date = .now,
        dateModified: Date = .now
    ) {
        self.position = position
        self.song = song
        self.setlist = setlist
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}
