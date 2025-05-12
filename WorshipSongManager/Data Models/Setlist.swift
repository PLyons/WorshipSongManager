//
//  Setlist.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/12/25.
//

import Foundation
import SwiftData

@Model
class Setlist {
    var id: UUID
    var name: String
    var date: Date?
    var dateCreated: Date
    var dateModified: Date
    var notes: String?
    
    // Relationship
    var items: [SetlistItem]?

    init(
        id: UUID = UUID(),
        name: String,
        date: Date? = nil,
        dateCreated: Date = .now,
        dateModified: Date = .now,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.notes = notes
    }
}
