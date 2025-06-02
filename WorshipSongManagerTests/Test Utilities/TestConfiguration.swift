//
//  TestConfiguration.swift
//  WorshipSongManagerTests
//
//  Created by Paul Lyons on 2025-06-02
//

import Foundation

enum TestConfiguration {
    // MARK: - Test Data Sizes
    static let quickTestDataSize = 10
    static let performanceTestDataSize = 1000
    static let maxLoadTime: TimeInterval = 2.0
    static let maxSearchTime: TimeInterval = 0.5
    
    // MARK: - Test Song Data
    static let testSongTitles = [
        "Amazing Grace",
        "How Great Thou Art",
        "Great Is Thy Faithfulness",
        "Holy Holy Holy",
        "Blessed Assurance",
        "It Is Well With My Soul",
        "What a Friend We Have in Jesus",
        "Be Thou My Vision",
        "How Firm a Foundation",
        "Rock of Ages"
    ]
    
    static let testArtists = [
        "John Newton",
        "Carl Boberg",
        "Thomas Chisholm",
        "Reginald Heber",
        "Fanny Crosby",
        "Horatio Spafford",
        "Joseph Scriven",
        "Ancient Irish Hymn",
        "Rippon's Selection",
        "Augustus Toplady"
    ]
    
    static let testKeys = ["C", "C#", "Db", "D", "D#", "Eb", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"]
    
    static let testTempos = [60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180]
    
    // MARK: - Test Setlist Data
    static let testSetlistNames = [
        "Sunday Morning Worship",
        "Evening Service",
        "Youth Group",
        "Christmas Service",
        "Easter Celebration",
        "Prayer Meeting",
        "Special Event",
        "Communion Service",
        "Baptism Service",
        "Wedding Ceremony"
    ]
    
    // MARK: - Sample Content
    static let sampleLyrics = """
        Verse 1:
        Amazing grace how sweet the sound
        That saved a wretch like me
        I once was lost but now am found
        Was blind but now I see
        
        Chorus:
        'Twas grace that taught my heart to fear
        And grace my fears relieved
        How precious did that grace appear
        The hour I first believed
        
        Verse 2:
        Through many dangers, toils, and snares
        I have already come
        'Tis grace hath brought me safe thus far
        And grace will lead me home
        """
    
    // MARK: - Validation Constants
    static let maxTitleLength = 100
    static let maxArtistLength = 100
    static let minTempo = 40
    static let maxTempo = 300
    
    // MARK: - Test Environment
    static let isRunningTests: Bool = {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }()
    
    // MARK: - Helper Methods
    static func randomSongTitle() -> String {
        return testSongTitles.randomElement() ?? "Test Song"
    }
    
    static func randomArtist() -> String {
        return testArtists.randomElement() ?? "Test Artist"
    }
    
    static func randomKey() -> String {
        return testKeys.randomElement() ?? "C"
    }
    
    static func randomTempo() -> Int16 {
        return Int16(testTempos.randomElement() ?? 120)
    }
    
    static func randomSetlistName() -> String {
        return testSetlistNames.randomElement() ?? "Test Setlist"
    }
}

// MARK: - Test Data Validation
extension TestConfiguration {
    static func isValidTestTitle(_ title: String) -> Bool {
        return !title.isEmpty && title.count <= maxTitleLength
    }
    
    static func isValidTestArtist(_ artist: String) -> Bool {
        return artist.count <= maxArtistLength
    }
    
    static func isValidTestTempo(_ tempo: Int16) -> Bool {
        return tempo == 0 || (tempo >= minTempo && tempo <= maxTempo)
    }
    
    static func isValidTestKey(_ key: String) -> Bool {
        return key.isEmpty || testKeys.contains(key)
    }
}
