//
//  MainTabView.swift
//  WorshipSongManager
//
//  Created by Developer on 2025-05-25
//

import SwiftUI
import CoreData

struct MainTabView: View {
    let context: NSManagedObjectContext
    
    var body: some View {
        TabView {
            // Songs Tab
            SongListView(context: context)
                .tabItem {
                    Label("Songs", systemImage: "music.note")
                }
            
            // Setlists Tab
            SetlistListView(context: context)
                .tabItem {
                    Label("Setlists", systemImage: "list.bullet")
                }
            
            // Settings Tab (Placeholder for future)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.blue) // Customize tab bar accent color
    }
}

// MARK: - Placeholder Settings View

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "gear")
                    .font(.system(size: 64))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("App settings and preferences will be available here in a future update")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding(40)
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewPersistenceController.shared.viewContext
        MainTabView(context: context)
            .environment(\.managedObjectContext, context)
    }
}
