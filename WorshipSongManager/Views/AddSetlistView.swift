//
//  AddSetlistView.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/15/25.
//  Modified by Architect on 05/15/25
//

import SwiftUI
import CoreData

struct AddSetlistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @State private var name = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Setlist Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("New Setlist")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newSetlist = Setlist(context: viewContext)
                        newSetlist.id = UUID()  // ✅ Explicit assignment
                        newSetlist.name = name
                        newSetlist.date = date
                        newSetlist.dateCreated = Date()
                        newSetlist.dateModified = Date()
                        try? viewContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddSetlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddSetlistView()
            .environment(\.managedObjectContext, PreviewPersistenceController.shared.viewContext)
    }
}
