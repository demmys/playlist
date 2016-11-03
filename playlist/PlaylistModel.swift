//
//  PlaylistModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/29.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistModel : AudioModelDelegate, RemoteControlModelDelegate {
    enum RepeatMode {
        case noRepeat
        case allRepeat
        case singleRepeat
    }

    enum ShuffleMode {
        case noShuffle
        case allShuffle
    }

    private weak var _delegate: PlaylistModelDelegate?
    private var _remoteControl: RemoteControlModel!
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
        _remoteControl = RemoteControlModel(delegate: self)
        guard let startAudio = buildAudio(withItem: _items[_pointer], playSoon: false) else {
            return nil
        }
        _playingAudio = startAudio
        notifyItemDidChange()
    }

    deinit {
        if _playingAudio.isPlaying {
            _playingAudio.stop()
        }
    }

    func releaseCache() {
        _nextAudioCache = nil
        _prevAudioCache = nil
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

    /*
     * Audio control methods
     */
    func togglePlay() -> Bool {
        if _playingAudio.isPlaying {
            _playingAudio.pause()
            return false
        }
        _playingAudio.play()
        return true
    }

    func next(onNextExist: ((Void) -> Void)? = nil) {
        let interrupting = _playingAudio.isPlaying
        _playingAudio.stop()
        if let nextAudio = getCachedNext() {
            _prevAudioCache = _playingAudio
            _playingAudio = nextAudio
            _pointer += 1
        } else {
            guard case .allRepeat = _repeatMode, let firstItem = _items.first else {
                _prevAudioCache = _playingAudio
                _delegate?.playlistDidFinish()
                return
            }
            _prevAudioCache = nil
            _playingAudio = buildAudio(withItem: firstItem, playSoon: true)
            _pointer = 0
        }
        if interrupting {
            _playingAudio.play()
        }
        if let callback = onNextExist {
            callback()
        }
        notifyItemDidChange()
    }

    func prev() {
        let interrupting = _playingAudio.isPlaying
        guard !interrupting || _playingAudio.inBeginning else {
            return _playingAudio.cue()
        }
        _playingAudio.stop()
        if let prevAudio = getCachedPrev() {
            _nextAudioCache = _playingAudio
            _playingAudio = prevAudio
            _pointer -= 1
        } else {
            if case .allRepeat = _repeatMode, let lastItem = _items.last {
                _nextAudioCache = _playingAudio
                _playingAudio = buildAudio(withItem: lastItem, playSoon: true)
                _pointer = _items.count - 1
            } else {
                _playingAudio.cue()
            }
        }
        if interrupting {
            _playingAudio.play()
        }
        notifyItemDidChange()
    }

    /*
     * AudioModelDelegate
     */
    func playingAudioDidFinish(successfully flag: Bool) {
        if case .singleRepeat = _repeatMode {
            _playingAudio.cue()
            return _playingAudio.play()
        }
        next(onNextExist: { self._playingAudio.play() })
    }

    /*
     * RemoteControlModelDelegate
     */
    func didReceivePlay() {
        _playingAudio.play()
        _delegate?.didPlayByRemote()
    }

    func didReceivePause() {
        _playingAudio.pause()
        _delegate?.didPauseByRemote()
    }

    func didReceiveTogglePlay() {
        if _playingAudio.isPlaying {
            _playingAudio.pause()
            _delegate?.didPauseByRemote()
        } else {
            _playingAudio.play()
            _delegate?.didPlayByRemote()
        }
    }

    func didReceiveNext() {
        next()
    }

    func didReceivePrev() {
        prev()
    }

    /*
     * Helper methods
     */
    private func buildAudio(withItem item: MPMediaItem, playSoon: Bool) -> AudioModel? {
        return AudioModel(withItem: item, playSoon: !playSoon, delegate: self)
    }

    private func getCachedNext() -> AudioModel? {
        func cacheNext() {
            let afterNextPoint = _pointer + 2
            guard afterNextPoint < _items.count else {
                _nextAudioCache = nil
                return
            }
            _nextAudioCache = buildAudio(withItem: _items[afterNextPoint], playSoon: false)
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
            guard 0 <= beforePrevPoint else {
                _prevAudioCache = nil
                return
            }
            _prevAudioCache = buildAudio(withItem: _items[beforePrevPoint], playSoon: false)
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

    private func notifyItemDidChange() {
        let info = AudioInfoModel(ofItem: _items[_pointer])
        _delegate?.playingItemDidChange(info)
        _remoteControl.updateNowPlayingInfo(withInfo: info)
    }
}
