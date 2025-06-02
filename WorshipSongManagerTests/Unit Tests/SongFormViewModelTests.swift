//
//  SongFormViewModelTests.swift
//  WorshipSongManagerTests
//
//  Created by Paul Lyons on 2025-06-02
//

import XCTest
import CoreData
@testable import WorshipSongManager

@MainActor
final class SongFormViewModelTests: XCTestCase {
    
    var sut: SongFormViewModel! // System Under Test
    var mockContext: NSManagedObjectContext!
    var testContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create in-memory Core Data stack for testing
        testContainer = NSPersistentContainer(name: "WorshipSongManager")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        testContainer.persistentStoreDescriptions = [description]
        
        let expectation = expectation(description: "Store loaded")
        testContainer.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to load test store: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        mockContext = testContainer.viewContext
        mockContext.automaticallyMergesChangesFromParent = false
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockContext = nil
        testContainer = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testInit_AddMode_SetsDefaultValues() throws {
        // Given & When
        sut = SongFormViewModel(context: mockContext, mode: .add)
        
        // Then
        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.artist, "")
        XCTAssertEqual(sut.key, "")
        XCTAssertEqual(sut.tempo, "")
        XCTAssertEqual(sut.timeSignature, "4/4")
        XCTAssertFalse(sut.isFavorite)
        XCTAssertFalse(sut.isPublicDomain)
        XCTAssertTrue(sut.validationErrors.isEmpty)
        XCTAssertEqual(sut.navigationTitle, "Add Song")
        XCTAssertEqual(sut.saveButtonTitle, "Create")
    }
    
    func testInit_EditMode_PopulatesFromSong() throws {
        // Given
        let song = createTestSong()
        
        // When
        sut = SongFormViewModel(context: mockContext, mode: .edit(song))
        
        // Then
        XCTAssertEqual(sut.title, song.title)
        XCTAssertEqual(sut.artist, song.artist)
        XCTAssertEqual(sut.key, song.key)
        XCTAssertEqual(sut.tempo, String(song.tempo))
        XCTAssertEqual(sut.isFavorite, song.isFavorite)
        XCTAssertEqual(sut.navigationTitle, "Edit Song")
        XCTAssertEqual(sut.saveButtonTitle, "Save Changes")
    }
    
    // MARK: - Validation Tests
    
    func testValidation_EmptyTitle_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = ""
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Title is required"))
    }
    
    func testValidation_WhitespaceOnlyTitle_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "   "
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Title is required"))
    }
    
    func testValidation_ValidTitle_NoError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Amazing Grace"
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertFalse(sut.validationErrors.contains("Title is required"))
    }
    
    func testValidation_TitleTooLong_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = String(repeating: "a", count: 101) // 101 characters
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Title must be less than 100 characters"))
    }
    
    func testValidation_EmptyKey_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = ""
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Key is required"))
    }
    
    func testValidation_ValidKey_NoError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertFalse(sut.validationErrors.contains("Key is required"))
    }
    
    func testValidation_InvalidTempo_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.tempo = "abc"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Tempo must be a number"))
    }
    
    func testValidation_TooSlowTempo_ShowsWarning() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.tempo = "30"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Tempo seems too slow (minimum 40 BPM recommended)"))
    }
    
    func testValidation_TooFastTempo_ShowsWarning() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.tempo = "350"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Tempo seems too fast (maximum 300 BPM recommended)"))
    }
    
    func testValidation_EmptyTempo_IsValid() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.tempo = ""
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertFalse(sut.validationErrors.contains { $0.contains("Tempo") })
    }
    
    func testValidation_ValidTempo_NoError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.tempo = "120"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertFalse(sut.validationErrors.contains { $0.contains("Tempo") })
    }
    
    func testValidation_ArtistTooLong_ShowsError() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.artist = String(repeating: "a", count: 101) // 101 characters
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.validationErrors.contains("Artist name must be less than 100 characters"))
    }
    
    // MARK: - Save Operation Tests
    
    func testSave_AddMode_CreatesNewSong() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "New Song"
        sut.artist = "Test Artist"
        sut.key = "G"
        sut.tempo = "120"
        sut.content = "Amazing lyrics here"
        sut.isFavorite = true
        
        let initialCount = try mockContext.count(for: Song.fetchRequest())
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        let finalCount = try mockContext.count(for: Song.fetchRequest())
        XCTAssertEqual(finalCount, initialCount + 1)
        
        // Verify song properties
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "New Song")
        let songs = try mockContext.fetch(request)
        XCTAssertEqual(songs.count, 1)
        
        let song = songs.first!
        XCTAssertEqual(song.title, "New Song")
        XCTAssertEqual(song.artist, "Test Artist")
        XCTAssertEqual(song.key, "G")
        XCTAssertEqual(song.tempo, 120)
        XCTAssertEqual(song.content, "Amazing lyrics here")
        XCTAssertTrue(song.isFavorite)
        XCTAssertNotNil(song.dateCreated)
        XCTAssertNotNil(song.dateModified)
    }
    
    func testSave_EditMode_UpdatesExistingSong() async throws {
        // Given
        let originalSong = createTestSong()
        let originalDateModified = originalSong.dateModified
        sut = SongFormViewModel(context: mockContext, mode: .edit(originalSong))
        
        // Small delay to ensure different timestamp
        try await Task.sleep(nanoseconds: 1_000_000) // 1ms
        
        sut.title = "Updated Title"
        sut.artist = "Updated Artist"
        sut.tempo = "140"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(originalSong.title, "Updated Title")
        XCTAssertEqual(originalSong.artist, "Updated Artist")
        XCTAssertEqual(originalSong.tempo, 140)
        XCTAssertNotNil(originalSong.dateModified)
        XCTAssertTrue(originalSong.dateModified! > originalDateModified!)
    }
    
    func testSave_InvalidData_ReturnsFalse() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "" // Invalid - empty title
        sut.key = "C"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertFalse(result)
        XCTAssertFalse(sut.validationErrors.isEmpty)
    }
    
    // MARK: - Loading State Tests
    
    func testSave_SetsLoadingState() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        
        // When
        let saveTask = Task {
            await sut.save()
        }
        
        // Then - loading state should be false after completion
        await saveTask.value
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - Data Sanitization Tests
    
    func testSave_TrimsWhitespace() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "  Test Song  "
        sut.artist = "  Test Artist  "
        sut.key = "  C  "
        sut.content = "  Test content  "
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Test Song")
        let songs = try mockContext.fetch(request)
        
        let song = songs.first!
        XCTAssertEqual(song.title, "Test Song") // Whitespace trimmed
        XCTAssertEqual(song.artist, "Test Artist") // Whitespace trimmed
        XCTAssertEqual(song.key, "C") // Whitespace trimmed
        XCTAssertEqual(song.content, "Test content") // Whitespace trimmed
    }
    
    func testSave_EmptyOptionalFields_SavesAsNil() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.artist = ""
        sut.content = ""
        sut.copyright = ""
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Test Song")
        let songs = try mockContext.fetch(request)
        
        let song = songs.first!
        XCTAssertNil(song.artist) // Empty string becomes nil
        XCTAssertNil(song.content) // Empty string becomes nil
        XCTAssertNil(song.copyright) // Empty string becomes nil
    }
    
    // MARK: - Public Domain and Copyright Tests
    
    func testSave_PublicDomain_ClearsRopyright() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.isPublicDomain = true
        sut.copyright = "Some copyright"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        let songs = try mockContext.fetch(request)
        let song = songs.first!
        
        XCTAssertNil(song.copyright) // Should be nil when public domain
    }
    
    func testSave_NotPublicDomain_KeepsCopyright() async throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Test Song"
        sut.key = "C"
        sut.isPublicDomain = false
        sut.copyright = "© 2024 Test Publisher"
        
        // When
        let result = await sut.save()
        
        // Then
        XCTAssertTrue(result)
        
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        let songs = try mockContext.fetch(request)
        let song = songs.first!
        
        XCTAssertEqual(song.copyright, "© 2024 Test Publisher")
    }
    
    // MARK: - Cancel Tests
    
    func testCancel_EditMode_RestoresOriginalValues() throws {
        // Given
        let originalSong = createTestSong()
        sut = SongFormViewModel(context: mockContext, mode: .edit(originalSong))
        
        // Modify values
        sut.title = "Modified Title"
        sut.artist = "Modified Artist"
        
        // When
        sut.cancel()
        
        // Then
        XCTAssertEqual(sut.title, originalSong.title)
        XCTAssertEqual(sut.artist, originalSong.artist)
        XCTAssertTrue(sut.validationErrors.isEmpty)
    }
    
    func testCancel_AddMode_ClearsForm() throws {
        // Given
        sut = SongFormViewModel(context: mockContext, mode: .add)
        sut.title = "Some Title"
        sut.artist = "Some Artist"
        sut.validationErrors = ["Some error"]
        
        // When
        sut.cancel()
        
        // Then
        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.artist, "")
        XCTAssertTrue(sut.validationErrors.isEmpty)
    }
    
    // MARK: - Helper Methods
    
    private func createTestSong() -> Song {
        let song = Song(context: mockContext)
        song.title = "Test Song"
        song.artist = "Test Artist"
        song.key = "C"
        song.tempo = 120
        song.timeSignature = "4/4"
        song.content = "Test lyrics"
        song.isFavorite = false
        song.dateCreated = Date()
        song.dateModified = Date()
        
        try! mockContext.save()
        return song
    }
}
