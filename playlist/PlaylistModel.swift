//
//  PlaylistModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/29.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistModel : AudioModelDelegate {
    enum RepeatMode {
        case noRepeat
        case allRepeat
        case singleRepeat
    }

    enum ShuffleMode {
        case noShuffle
        case allShuffle
    }

    private let _delegate: PlaylistModelDelegate
    private var _repeatMode: RepeatMode = .noRepeat
    private var _shuffleMode: ShuffleMode = .noShuffle
    private var _items: [MPMediaItem]
    private var _pointer: Int
    private var _playingAudio: AudioModel!
    private var _nextAudioCache: AudioModel?
    private var _prevAudioCache: AudioModel?

    var playingItem: MPMediaItem {
        get { return _items[_pointer] }
    }

    init?(withItems items: [MPMediaItem], startIndex: Int, delegate: PlaylistModelDelegate) {
        guard startIndex < items.count else {
            return nil
        }
        _items = items
        _pointer = startIndex
        _delegate = delegate
        guard let startAudio = buildAudio(withItem: _items[_pointer], playSoon: true) else {
            return nil
        }
        _playingAudio = startAudio
    }

    deinit {
        if _playingAudio.isPlaying {
            _playingAudio.stop()
        }
    }

    func setRepeatMode(_ mode: RepeatMode) {
        _repeatMode = mode
    }

    func setShuffleMode(_ mode: ShuffleMode) {
        _shuffleMode = mode
        // TODO: shuffle remaining list
    }

    func insert(items: [MPMediaItem]) {
        // TODO: insert and change next cache
    }

    func append(items: [MPMediaItem]) {
        // TODO: append and change next cache if changed
    }

    func togglePlay() -> Bool {
        if _playingAudio.isPlaying {
            _playingAudio.pause()
            return false
        }
        _playingAudio.play()
        return true
    }

    func next() -> Bool {
        let interrupting = _playingAudio.isPlaying
        if interrupting {
            _playingAudio.stop()
        }
        _prevAudioCache = _playingAudio
        if let nextAudio = getCachedNext() {
            _playingAudio = nextAudio
            _pointer += 1
        } else {
            guard case .allRepeat = _repeatMode else {
                return false
            }
            _playingAudio = buildAudio(withItem: _items[0], playSoon: true)
            _pointer = 0
        }
        if interrupting {
            _playingAudio.play()
        }
        return true
    }

    func prev() -> Bool {
        // TODO: rewind option
        let interrupting = _playingAudio.isPlaying
        if interrupting {
            _playingAudio.stop()
        }
        _nextAudioCache = _playingAudio
        guard let prevAudio = getCachedPrev() else {
            return false
        }
        _playingAudio = prevAudio
        _pointer -= 1
        if interrupting {
            _playingAudio.play()
        }

        return true
    }

    func playingAudioDidFinish(successfully flag: Bool) {
        if case .singleRepeat = _repeatMode {
            _playingAudio.begin()
            return _playingAudio.play()
        }
        guard next() else {
            return _delegate.playlistDidFinish()
        }
        _delegate.playingItemDidChange(_items[_pointer])
        _playingAudio.play()
    }

    private func buildAudio(withItem item: MPMediaItem, playSoon: Bool) -> AudioModel? {
        return AudioModel(withItem: item, playSoon: !playSoon, delegate: self)
    }

    private func getCachedNext() -> AudioModel? {
        func cacheNext() {
            let afterNextPoint = _pointer + 2
            if afterNextPoint < _items.count {
                _nextAudioCache = buildAudio(withItem: _items[afterNextPoint], playSoon: false)
            }
        }

        if let nextAudio = _nextAudioCache {
            cacheNext()
            return nextAudio
        }
        let nextPoint = _pointer + 1
        guard nextPoint < _items.count else {
            return nil
        }
        cacheNext()
        return buildAudio(withItem: _items[nextPoint], playSoon: true)
    }

    private func getCachedPrev() -> AudioModel? {
        func cachePrev() {
            let beforePrevPoint = _pointer - 2
            if 0 < beforePrevPoint {
                _prevAudioCache = buildAudio(withItem: _items[beforePrevPoint], playSoon: false)
            }
        }

        if let prevAudio = _prevAudioCache {
            cachePrev()
            return prevAudio
        }
        let prevPoint = _pointer - 1
        guard 0 < prevPoint else {
            return nil
        }
        cachePrev()
        return buildAudio(withItem: _items[prevPoint], playSoon: true)
    }
}
