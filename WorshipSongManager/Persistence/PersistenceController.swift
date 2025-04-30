//
//  PersistenceController.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/30/25.
//

import CoreData
import CloudKit

class PersistenceController {
    // Shared instance for easy access throughout the app
    static let shared = PersistenceController()
    
    // Storage for CoreData
    let container: NSPersistentCloudKitContainer
    
    // A test configuration for previewing UI
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Create example data for preview
        let viewContext = controller.container.viewContext
        
        // Add sample song
        let newSong = Song(context: viewContext)
        newSong.id = UUID()
        newSong.title = "Amazing Grace"
        newSong.artist = "John Newton"
        newSong.content = "[C]Amazing [G]grace how [F]sweet the [C]sound"
        newSong.key = "C"
        newSong.dateCreated = Date()
        newSong.dateModified = Date()
        newSong.isFavorite = true
        
        // Add sample setlist
        let newSetlist = Setlist(context: viewContext)
        newSetlist.id = UUID()
        newSetlist.name = "Sunday Morning"
        newSetlist.date = Date()
        newSetlist.dateCreated = Date()
        newSetlist.dateModified = Date()
        
        // Connect song to setlist
        let songInSetlist = SongInSetlist(context: viewContext)
        songInSetlist.id = UUID()
        songInSetlist.order = 1
        songInSetlist.song = newSong
        songInSetlist.setlist = newSetlist
        
        // Save the context
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "WorshipSongManager")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in shipping app - handle errors properly
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Enable automatic merging of changes from the parent
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Enable constraints validation
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Core Data Saving support
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Convenience Methods for Fetching
    func fetchSongsByTitle() -> [Song] {
        let request = Song.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching songs: \(error)")
            return []
        }
    }
    
    func fetchRecentSetlists(limit: Int = 10) -> [Setlist] {
        let request = Setlist.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateModified", ascending: false)]
        request.fetchLimit = limit
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching setlists: \(error)")
            return []
        }
    }
    
    func fetchFavoriteSongs() -> [Song] {
        let request = Song.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching favorite songs: \(error)")
            return []
        }
    }
}
