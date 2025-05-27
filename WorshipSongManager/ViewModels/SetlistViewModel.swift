//
//  SetlistListViewModel.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 2025-05-25
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class SetlistListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    
    // MARK: - Published Properties
    @Published var setlists: [Setlist] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingErrorAlert: Bool = false
    @Published var showingAddSheet: Bool = false
    
    // MARK: - Computed Properties
    var filteredSetlists: [Setlist] {
        guard !searchText.isEmpty else { return setlists }
        let lowercasedQuery = searchText.lowercased()
        return setlists.filter { setlist in
            (setlist.name ?? "").lowercased().contains(lowercasedQuery)
        }
    }
    
    var isEmpty: Bool {
        setlists.isEmpty
    }
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func fetchSetlists() async {
        isLoading = true
        errorMessage = nil
        
        let request: NSFetchRequest<Setlist> = Setlist.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Setlist.dateCreated, ascending: false)
        ]
        
        do {
            setlists = try context.fetch(request)
        } catch {
            errorMessage = "Failed to load setlists: \(error.localizedDescription)"
            showingErrorAlert = true
            setlists = []
        }
        
        isLoading = false
    }
    
    func refreshSetlists() {
        Task {
            await fetchSetlists()
        }
    }
    
    func deleteSetlists(at offsets: IndexSet) async {
        let setlistsToDelete = offsets.map { filteredSetlists[$0] }
        
        isLoading = true
        
        do {
            for setlist in setlistsToDelete {
                context.delete(setlist)
            }
            
            try context.save()
            await fetchSetlists() // Refresh after deletion
            
        } catch {
            errorMessage = "Failed to delete setlists: \(error.localizedDescription)"
            showingErrorAlert = true
        }
        
        isLoading = false
    }
    
    func createNewSetlist(name: String, date: Date) async -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Setlist name is required"
            showingErrorAlert = true
            return false
        }
        
        isLoading = true
        
        do {
            let newSetlist = Setlist(context: context)
            newSetlist.id = UUID()
            newSetlist.name = name.trimmingCharacters(in: .whitespaces)
            newSetlist.date = date
            newSetlist.dateCreated = Date()
            newSetlist.dateModified = Date()
            
            try context.save()
            await fetchSetlists() // Refresh after creation
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to create setlist: \(error.localizedDescription)"
            showingErrorAlert = true
            isLoading = false
            return false
        }
    }
    
    // MARK: - Helper Methods
    
    func clearError() {
        errorMessage = nil
        showingErrorAlert = false
    }
}
