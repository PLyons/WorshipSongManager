//
//  PreviewHelpers.swift
//  WorshipSongManager
//
//  Created by Paul Lyons on 5/13/25.
//

import Foundation

@MainActor
func previewSong() -> Song {
    let song = Song()
    song.title = "Amazing Grace"
    song.artist = "John Newton"
    song.key = "G"
    song.tempo = 90
    song.timeSignature = "3/4"
    song.copyright = "Public Domain"
    song.isFavorite = true
    song.content = """
    [G]Amazing grace how [D]sweet the sound
    That [G]saved a wretch like [D]me
    I [G]once was lost but [C]now am found
    Was [G]blind but [D]now I [G]see
    """
    return song
}
