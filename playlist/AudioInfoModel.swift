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

    let title: String
    let artist: String
    let album: String
    let albumArtist: String
    let artwork: MPMediaItemArtwork?
    let playlist: String
    let duration: TimeInterval

    private init() {
        title = AudioInfoModel.NoText
        artist = AudioInfoModel.NoText
        album = AudioInfoModel.NoText
        albumArtist = AudioInfoModel.NoText
        artwork = nil
        playlist = AudioInfoModel.NoText
        duration = 0
    }
    
    init(ofItem item: MPMediaItem, withInPlaylist playlistName: String? = nil) {
        let artistInfo = item.artist ?? AudioInfoModel.NoText
        title = item.title ?? AudioInfoModel.NoText
        artist = artistInfo
        album = item.albumTitle ?? AudioInfoModel.NoText
        albumArtist = item.albumArtist ?? artistInfo
        artwork = item.artwork
        playlist = playlistName ?? AudioInfoModel.NoText
        duration = item.playbackDuration
    }
    
    func artworkImage(ofSize size: CGSize) -> UIImage? {
        guard let mediaItemArtwork = artwork else {
            return nil
        }
        return mediaItemArtwork.image(at: size)
    }
}
