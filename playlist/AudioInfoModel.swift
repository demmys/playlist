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
    private static let NO_TEXT = "-"

    let artist: String
    let album: String
    let title: String
    let artwork: MPMediaItemArtwork?

    init() {
        artist = AudioInfoModel.NO_TEXT
        title = AudioInfoModel.NO_TEXT
        album = AudioInfoModel.NO_TEXT
        artwork = nil
    }
    init(ofItem item: MPMediaItem) {
        artist = item.artist ?? AudioInfoModel.NO_TEXT
        title = item.title ?? AudioInfoModel.NO_TEXT
        album = item.albumTitle ?? AudioInfoModel.NO_TEXT
        artwork = item.artwork
    }
}
