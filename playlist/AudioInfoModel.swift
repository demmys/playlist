//
//  AudioInfoModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class AudioInfoModel {
    private static let NoText = "-"
    static let EmptyAudioInfo = AudioInfoModel()

    let originalItem: MPMediaItem?
    let title: String
    let artist: String
    let album: String
    let albumArtist: String
    let hasAlbumArtist: Bool
    let artwork: MPMediaItemArtwork?
    let genre: String
    let duration: TimeInterval
    let trackNo: Int

    private init() {
        originalItem = nil
        title = AudioInfoModel.NoText
        artist = AudioInfoModel.NoText
        album = AudioInfoModel.NoText
        albumArtist = AudioInfoModel.NoText
        hasAlbumArtist = false
        artwork = nil
        genre = AudioInfoModel.NoText
        duration = 0
        trackNo = 0
    }
    
    init(ofItem item: MPMediaItem) {
        originalItem = item
        let artistInfo = item.artist ?? AudioInfoModel.NoText
        title = item.title ?? AudioInfoModel.NoText
        artist = artistInfo
        album = item.albumTitle ?? AudioInfoModel.NoText
        albumArtist = item.albumArtist ?? artistInfo
        hasAlbumArtist = item.albumArtist != nil
        artwork = item.artwork
        genre = item.genre ?? AudioInfoModel.NoText
        duration = item.playbackDuration
        trackNo = item.albumTrackNumber
    }
    
    func artworkImage(ofSize size: CGSize) -> UIImage? {
        guard let mediaItemArtwork = artwork else {
            return nil
        }
        return mediaItemArtwork.image(at: size)
    }
}
