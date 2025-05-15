//
//  PreviewPersistenceController.swift
//  WorshipSongManager
//
//  Created by Architect on 05/15/25
//

import CoreData

enum PreviewPersistenceController {
    static var shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorshipSongManager")
        let description = container.persistentStoreDescriptions.first
        description?.url = URL(fileURLWithPath: "/dev/null") // In-memory store
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Preview store failed to load: \(error)")
            }
        }

        // Add mock data
        let context = container.viewContext

        let song = Song(context: context)
        song.title = "Amazing Grace"
        song.artist = "John Newton"
        song.key = "G"
        song.tempo = 90
        song.timeSignature = "3/4"
        song.content = "Amazing grace, how sweet the sound"
        song.dateCreated = Date()

        let setlist = Setlist(context: context)
        setlist.name = "Sunday Worship"
        setlist.date = Date()
        setlist.dateCreated = Date()

        try? context.save()

        return container
    }()
}
