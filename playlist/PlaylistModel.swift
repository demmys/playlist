//
//  PlaylistModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistModel : AudioModelDelegate {
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
    
    private weak var _delegate: PlaylistModelDelegate!
    private var _items: [MPMediaItem]
    private var _playing: CachedAudioModel!
    private var _nextCache: CachedAudioModel?
    private var _prevCache: CachedAudioModel?
    
    var repeatMode: RepeatMode = .noRepeat {
        didSet(mode) {
            if mode == .allRepeat {
                updateCache()
            }
        }
    }
    
    var items: [MPMediaItem] {
        return _items
    }
    
    var playingItem: MPMediaItem {
        return _playing.item
    }
    
    var isPlaying: Bool {
        return _playing.audio.isPlaying
    }
    
    var inBeginning: Bool {
        return _playing.audio.inBeginning
    }
    
    init?(withItems items: [MPMediaItem], startIndex: Int, withDelegate delegate: PlaylistModelDelegate) {
        _delegate = delegate
        _items = items
        guard let startAudio = buildCachedAudioModel(ofIndex: startIndex, playSoon: true) else {
            return nil
        }
        _playing = startAudio
        updateCache()
    }
    
    /*
     * AudioModelDelegate
     */
    func playingAudioTimeDidElapse(sender: AudioModel) {
        if sender == _playing.audio {
            if sender.remains < 10 {
                prepareNextPlay()
            }
            _delegate.playingAudioTimeDidElapse(currentTime: sender.currentTime, wholeDuration: sender.duration)
        }
    }
    
    func playingAudioDidFinish() {
        if repeatMode == .singleRepeat {
            _playing.audio.cue()
        } else {
            guard changeTrackForward() else {
                return _delegate.playingAudioDidFinishAutomatically()
            }
            // When seeked end and finish before elapse
            if !_playing.audio.isPlaying {
                _playing.audio.play()
            }
            _delegate.playingAudioDidChangeAutomatically(changedTo: playingItem)
        }
    }
    
    /*
     * Playing list control methods
     */
    func insert(_ items: [MPMediaItem]) {
        _items.insert(contentsOf: items, at: _playing.index + 1)
        updateNextCache(forceUpdate: true)
    }

    func append(_ items: [MPMediaItem]) {
        let needToUpdateCache = _playing.index == _items.count - 1
        _items.append(contentsOf: items)
        if needToUpdateCache {
            updateNextCache(forceUpdate: true)
        }
    }
    
    /*
     * Audio control methods
     */
    func play() {
        _playing.audio.play()
    }
    
    func pause() {
        _playing.audio.pause()
        cancelNextPlayPreparation()
    }
    
    func cue() {
        _playing.audio.cue()
        cancelNextPlayPreparation()
    }
    
    func seek(toTime time: TimeInterval) {
        _playing.audio.seek(toTime: time)
        cancelNextPlayPreparation()
    }
    func seek(bySeconds seconds: Int, toForward forwarding: Bool) {
        _playing.audio.seek(bySeconds: seconds, toForward: forwarding)
        cancelNextPlayPreparation()
    }
    
    func stop() {
        _playing.audio.stop()
        cancelNextPlayPreparation()
    }
    
    func next() -> Bool {
        let interrupting = isPlaying
        stop()
        guard changeTrackForward() else {
            return false
        }
        if interrupting {
            play()
        }
        return true
    }
    
    func prev() -> Bool {
        let interrupting = isPlaying
        stop()
        guard changeTrackBackward() else {
            return false
        }
        if interrupting {
            play()
        }
        return true
    }
    
    func setPlayingIndex(_ index: Int) -> Bool {
        var actualIndex = index
        while actualIndex < 0 {
            actualIndex += _items.count
        }
        guard let startAudio = buildCachedAudioModel(ofIndex: actualIndex, playSoon: true) else {
            return false
        }
        _playing = startAudio
        updateCache()
        return true
    }

    /*
     * Helper methods
     */
    private func buildCachedAudioModel(ofIndex index: Int, playSoon: Bool) -> CachedAudioModel? {
        return CachedAudioModel(fromItems: _items, ofIndex: index, playSoon: playSoon, withDelegate: self)
    }

    private func changeTrackForward() -> Bool {
        guard let next = _nextCache else {
            return false
        }
        _prevCache = _playing
        _playing = next
        updateCache()
        return true
    }
    
    private func changeTrackBackward() -> Bool {
        guard let prev = _prevCache else {
            return false
        }
        _nextCache = _playing
        _playing = prev
        updateCache()
        return true
    }
    
    private func updateCache() {
        updatePrevCache()
        updateNextCache()
    }
    
    private func updatePrevCache(forceUpdate: Bool = false) {
        func cachePrevItemAsPrev() {
            _prevCache = buildCachedAudioModel(ofIndex: _playing.index - 1, playSoon: false)
        }
        func cacheLastItemAsPrev() {
            _prevCache = buildCachedAudioModel(ofIndex: _items.count - 1, playSoon: false)
        }
        
        if let prevCache = _prevCache, !forceUpdate {
            if case .allRepeat = repeatMode, _playing.index == 0 && prevCache.index != _items.count - 1 {
                cacheLastItemAsPrev()
            } else if prevCache.index != _playing.index - 1 {
                cachePrevItemAsPrev()
            }
        } else {
            if case .allRepeat = repeatMode, _playing.index == 0 {
                cacheLastItemAsPrev()
            } else {
                cachePrevItemAsPrev()
            }
        }
    }
    
    private func updateNextCache(forceUpdate: Bool = false) {
        func cacheNextItemAsNext() {
            _nextCache = buildCachedAudioModel(ofIndex: _playing.index + 1, playSoon: false)
        }
        func cacheFirstItemAsNext() {
            _nextCache = buildCachedAudioModel(ofIndex: 0, playSoon: false)
        }
        
        if let nextCache = _nextCache, !forceUpdate {
            if case .allRepeat = repeatMode, _playing.index + 1 == _items.count && nextCache.index != 0 {
                cacheFirstItemAsNext()
            } else if nextCache.index != _playing.index + 1 {
                cacheNextItemAsNext()
            }
        } else {
            if case .allRepeat = repeatMode, _playing.index + 1 == _items.count {
                cacheFirstItemAsNext()
            } else {
                cacheNextItemAsNext()
            }
        }
    }
    
    private func cancelNextPlayPreparation() {
        if let nextCache = _nextCache, nextCache.audio.isPlaying {
            nextCache.audio.stop()
        }
    }
    
    private func prepareNextPlay() {
        guard let nextCache = _nextCache else {
            return
        }
        if !nextCache.audio.isPlaying && self.repeatMode != .singleRepeat {
            nextCache.audio.play(withDelay: _playing.audio.remains)
        }
    }
}
