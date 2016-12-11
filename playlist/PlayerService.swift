//
//  PlayerService.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/09.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlayerService {
    static let shared = PlayerService()
    private var _playlistManager: PlaylistManagerModel?

    var playlist: PlaylistManagerModel? {
        return _playlistManager
    }
    
    func startPlaylist(ofItems items: [MPMediaItem], startIndex: Int) {
        if let oldPlaylist = _playlistManager, oldPlaylist.isPlaying {
            finishPlaylist()
        }
        _playlistManager = PlaylistManagerModel(withItems: items, startIndex: startIndex)
        _playlistManager?.togglePlay()
    }

    func finishPlaylist() {
        _playlistManager = nil
    }
}
