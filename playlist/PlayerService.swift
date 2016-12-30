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
    weak var delegate: PlayerServiceDelegate?
    private var _playlistManager: PlaylistManagerModel?

    var playlist: PlaylistManagerModel? {
        return _playlistManager
    }

    var hasPlaylist: Bool {
        return _playlistManager != nil
    }
    
    var playingIndex: Int? {
        return _playlistManager?.playingIndex
    }
    
    func startPlaylist(ofItems items: [MPMediaItem], startIndex: Int, willStartAutomatic: Bool = true) {
        if let oldPlaylist = _playlistManager, oldPlaylist.isPlaying {
            finishPlaylist()
        }
        _playlistManager = PlaylistManagerModel(withItems: items, startIndex: startIndex)
        if willStartAutomatic {
            _playlistManager?.togglePlay()
        }
        delegate?.playlistDidSet()
    }

    func finishPlaylist() {
        _playlistManager = nil
    }
    
    func appendSongs(_ items: [MPMediaItem]) {
        guard let playlistManager = _playlistManager else {
            return startPlaylist(ofItems: items, startIndex: 0, willStartAutomatic: false)
        }
        playlistManager.append(items)
    }
    
    func insertSongs(_ items: [MPMediaItem]) {
        guard let playlistManager = _playlistManager else {
            return startPlaylist(ofItems: items, startIndex: 0, willStartAutomatic: false)
        }
        playlistManager.insert(items)
    }
    
    func deleteSong(at index: Int) -> Bool {
        guard let playlistManager = _playlistManager else {
            return false
        }
        return playlistManager.delete(at: index)
    }
    
    func moveSong(from: Int, to: Int) -> Bool {
        guard let playlistManager = _playlistManager else {
            return false
        }
        return playlistManager.move(from: from, to: to)
    }
}
