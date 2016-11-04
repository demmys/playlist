//
//  CachedAudioModelCollection.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class CachedAudioModelCollection {
    struct CachedAudioModel {
        let index: Int
        let item: MPMediaItem
        let audio: AudioModel
        
        init?(fromItems items: [MPMediaItem], ofIndex index: Int, playSoon: Bool, withDelegate delegate: AudioModelDelegate) {
            guard 0 <= index && index < items.count else {
                return nil
            }
            self.index = index
            self.item = items[index]
            guard let audio = AudioModel(withItem: item, playSoon: playSoon, withDelegate: delegate) else {
                return nil
            }
            self.audio = audio
        }
    }
    
    private let _audioModelDelegate: AudioModelDelegate
    private var _items: [MPMediaItem]
    private var _playing: CachedAudioModel
    private var _nextCache: CachedAudioModel?
    private var _prevCache: CachedAudioModel?
    
    var playingItem: MPMediaItem {
        get { return _playing.item }
    }
    
    init?(withItems items: [MPMediaItem], startIndex: Int, withAudioModelDelegate audioModelDelegate: AudioModelDelegate) {
        guard let startAudio = CachedAudioModel(fromItems: items, ofIndex: startIndex, playSoon: true, withDelegate: audioModelDelegate) else {
            return nil
        }
        _audioModelDelegate = audioModelDelegate
        _items = items
        _playing = startAudio
        updateCache()
    }
    
    func next() -> AudioModel? {
        guard let next = _nextCache else {
            return nil
        }
        _prevCache = _playing
        _playing = next
        updateCache()
        return next.audio
    }
    
    func prev() -> AudioModel? {
        guard let prev = _prevCache else {
            return nil
        }
        _nextCache = _playing
        _playing = prev
        updateCache()
        return prev.audio
    }
    
    func setPlaying(fromIndex index: Int) -> Bool {
        guard let startAudio = CachedAudioModel(fromItems: _items, ofIndex: index, playSoon: true, withDelegate: _audioModelDelegate) else {
            return false
        }
        _playing = startAudio
        updateCache()
        return true
    }
    
    private func updateCache() {
        if _nextCache == nil || _nextCache!.index != _playing.index + 1 {
            _nextCache = CachedAudioModel(fromItems: _items, ofIndex: _playing.index + 1, playSoon: false, withDelegate: _audioModelDelegate)
        }
        if _prevCache == nil || _prevCache!.index != _playing.index - 1 {
            _prevCache = CachedAudioModel(fromItems: _items, ofIndex: _playing.index - 1, playSoon: false, withDelegate: _audioModelDelegate)
        }
    }
}
