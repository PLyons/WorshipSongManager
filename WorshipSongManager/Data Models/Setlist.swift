//
//  Setlist.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//  Modified by Paul Lyons on 5/13/25.
//

import Foundation
import SwiftData

@Model
class Setlist {
    var name: String
    var date: Date?
    var dateCreated: Date
    var dateModified: Date
    var notes: String?

    // Relationship
    var items: [SetlistItem]?

    init(
        name: String,
        date: Date? = nil,
        dateCreated: Date = .now,
        dateModified: Date = .now,
        notes: String? = nil
    ) {
        self.name = name
        self.date = date
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.notes = notes
    }
}
