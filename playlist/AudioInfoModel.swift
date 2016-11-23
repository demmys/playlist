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
    
    let artwork: MPMediaItemArtwork?
    let artist: String
    let album: String
    let title: String
    let duration: TimeInterval

    private init() {
        artwork = nil
        artist = AudioInfoModel.NoText
        title = AudioInfoModel.NoText
        album = AudioInfoModel.NoText
        duration = 0
    }

    init(ofItem item: MPMediaItem) {
        artwork = item.artwork
        artist = item.artist ?? AudioInfoModel.NoText
        title = item.title ?? AudioInfoModel.NoText
        album = item.albumTitle ?? AudioInfoModel.NoText
        duration = item.playbackDuration
    }
    
    func artworkImage(ofSize size: CGSize) -> UIImage? {
        guard let mediaItemArtwork = artwork else {
            return nil
        }
        return mediaItemArtwork.image(at: size)
    }
}
