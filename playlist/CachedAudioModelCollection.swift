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
    
    private weak var _audioModelDelegate: AudioModelDelegate!
    private var _items: [MPMediaItem]
    private var _playing: CachedAudioModel
    private var _nextCache: CachedAudioModel?
    private var _prevCache: CachedAudioModel?
    
    var playingItem: MPMediaItem {
        get { return _playing.item }
    }
    
    var isPlaying: Bool {
        get { return _playing.audio.isPlaying }
    }
    
    var inBeginning: Bool {
        get { return _playing.audio.inBeginning }
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
    
    func play() {
        _playing.audio.play()
    }
    
    func pause() {
        _playing.audio.pause()
    }
    
    func cue() {
        _playing.audio.cue()
    }
    
    func stop() {
        _playing.audio.stop()
    }
    
    func next() -> Bool {
        guard let next = _nextCache else {
            return false
        }
        _prevCache = _playing
        _playing = next
        updateCache()
        return true
    }
    
    func prev() -> Bool {
        guard let prev = _prevCache else {
            return false
        }
        _nextCache = _playing
        _playing = prev
        updateCache()
        return true
    }
    
    func setPlayingIndex(_ index: Int) -> Bool {
        var actualIndex = index
        while actualIndex < 0 {
            actualIndex += _items.count
        }
        guard let startAudio = CachedAudioModel(fromItems: _items, ofIndex: actualIndex, playSoon: true, withDelegate: _audioModelDelegate) else {
            return false
        }
        _playing = startAudio
        updateCache()
        return true
    }
    
    func releaseCache() {
        _prevCache = nil
        _nextCache = nil
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
