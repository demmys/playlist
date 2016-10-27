//
//  Player.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/26.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlayerModel {
    private let _player: MPMusicPlayerController
    private var _onItemChangedObserver: ((MPMediaItem?) -> Void)?
    private var playing = false

    init() {
        _player = MPMusicPlayerController.applicationMusicPlayer()
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(onItemChanged),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: _player
        )
    }
    
    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: _player)
        _player.endGeneratingPlaybackNotifications()
    }
    
    func play() {
        print("called play")
        _player.play()
        playing = true
    }
    
    func stop() {
        print("called stop")
        _player.stop()
        playing = false
    }
    
    func toggle() -> Bool {
        if playing {
            stop()
        } else {
            play()
        }
        print("result: \(playing)")
        return playing
    }
    
    func setQueue(collection: MPMediaItemCollection) {
        _player.stop()
        _player.setQueue(with: collection)
    }
    
    func setOnItemChanged(observer: @escaping (MPMediaItem?) -> Void) {
        _onItemChangedObserver = observer
    }
    
    @objc private func onItemChanged(notification: Notification) {
        if let observer = _onItemChangedObserver {
            observer(_player.nowPlayingItem)
        }
    }
}
