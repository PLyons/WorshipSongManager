//
//  SongSectionType.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 4/29/25.
//

import Foundation

enum SongSectionType: String, Codable, CaseIterable {
    case verse, chorus, preChorus, bridge, intro, outro, custom
    
    var displayName: String {
        switch self {
        case .verse: return "Verse"
        case .chorus: return "Chorus"
        case .preChorus: return "Pre-Chorus"
        case .bridge: return "Bridge"
        case .intro: return "Intro"
        case .outro: return "Outro"
        case .custom: return "Custom"
        }
    }
}
