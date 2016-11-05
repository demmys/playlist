//
//  CachedAudioModelCollection.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class CachedAudioModelCollection : AudioModelDelegate {
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
    
    private weak var _delegate: CachedAudioModelCollectionDelegate!
    private var _items: [MPMediaItem]
    private var _playing: CachedAudioModel!
    private var _nextCache: CachedAudioModel?
    private var _prevCache: CachedAudioModel?
    private var _nextPlayTimer: Timer?
    
    var repeatMode: RepeatMode = .noRepeat
    
    var playingItem: MPMediaItem {
        return _playing.item
    }
    
    var isPlaying: Bool {
        return _playing.audio.isPlaying
    }
    
    var inBeginning: Bool {
        return _playing.audio.inBeginning
    }
    
    init?(withItems items: [MPMediaItem], startIndex: Int, withDelegate delegate: CachedAudioModelCollectionDelegate) {
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
    func playingAudioDidElapse(sender: AudioModel) {
        if sender == _playing.audio {
            _delegate.playingAudioDidElapse(currentTime: sender.currentTime, wholeDuration: sender.duration)
        }
    }
    
    /*
     * Audio control methods
     */
    func play() {
        _playing.audio.play()
        setNextPlayTimer()
    }
    
    func pause() {
        _playing.audio.pause()
        unsetNextPlayTimer()
    }
    
    func cue() {
        _playing.audio.cue()
        resetNextPlayTimer()
    }
    
    func seek(toTime time: TimeInterval) {
        _playing.audio.seek(toTime: time)
        resetNextPlayTimer()
    }
    func seek(bySeconds seconds: Int, toForward forwarding: Bool) {
        _playing.audio.seek(bySeconds: seconds, toForward: forwarding)
        resetNextPlayTimer()
    }
    
    func stop() {
        _playing.audio.stop()
        unsetNextPlayTimer()
    }
    
    func next() -> Bool {
        let interrupting = isPlaying
        if interrupting {
            stop()
        }
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
        if interrupting {
            stop()
        }
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

    func releaseCache() {
        _prevCache = nil
        _nextCache = nil
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
    
    private func updatePrevCache() {
        func cachePrevItemAsPrev() {
            _prevCache = buildCachedAudioModel(ofIndex: _playing.index - 1, playSoon: false)
        }
        func cacheLastItemAsPrev() {
            _prevCache = buildCachedAudioModel(ofIndex: _items.count - 1, playSoon: false)
        }
        
        if let prevCache = _prevCache {
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
    
    private func updateNextCache() {
        func cacheNextItemAsNext() {
            _nextCache = buildCachedAudioModel(ofIndex: _playing.index + 1, playSoon: false)
        }
        func cacheFirstItemAsNext() {
            _nextCache = buildCachedAudioModel(ofIndex: 0, playSoon: false)
        }
        
        if let nextCache = _nextCache {
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
    
    private func unsetNextPlayTimer() {
        if let oldTimer = _nextPlayTimer, oldTimer.isValid {
            oldTimer.invalidate()
        }
    }
    
    private func setNextPlayTimer() {
        guard let nextCache = _nextCache else {
            return
        }
        _nextPlayTimer = Timer.scheduledTimer(withTimeInterval: _playing.audio.remains, repeats: false) { _ in
            if case .singleRepeat = self.repeatMode {
                self._playing.audio.cue()
            } else {
                nextCache.audio.play()
                _ = self.changeTrackForward()
                self._delegate.playingAudioDidChangeAutomatically(changedTo: self.playingItem)
            }
            self.resetNextPlayTimer()
        }
    }
    
    private func resetNextPlayTimer() {
        unsetNextPlayTimer()
        setNextPlayTimer()
    }
}
