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

    private weak var _delegate: PlaylistModelDelegate!
    private var _audioCollection: CachedAudioModelCollection!
    private var _remoteControl: RemoteControlModel!
    private var _repeatMode: RepeatMode = .noRepeat
    private var _shuffleMode: ShuffleMode = .noShuffle

    var playingItem: MPMediaItem {
        get { return _audioCollection.playingItem }
    }
    
    var isPlaying: Bool {
        get { return _audioCollection.isPlaying }
    }

    init?(withItems items: [MPMediaItem], startIndex: Int, delegate: PlaylistModelDelegate, playNow: Bool) {
        guard let audioCollection = CachedAudioModelCollection(withItems: items, startIndex: startIndex, withAudioModelDelegate: self) else {
            return nil
        }
        _delegate = delegate
        _audioCollection = audioCollection
        _remoteControl = RemoteControlModel(delegate: self)
        notifyItemDidChange()
        if playNow {
            _audioCollection.play()
            _delegate.didPlayAutomatically()
        }
    }

    deinit {
        if _audioCollection.isPlaying {
            _audioCollection.stop()
            _delegate.didPauseAutomatically()
        }
    }

    func releaseCache() {
        _audioCollection.releaseCache()
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
        if _audioCollection.isPlaying {
            _audioCollection.pause()
            return false
        }
        _audioCollection.play()
        return true
    }

    func next(onNextExist: ((Void) -> Void)? = nil) {
        let interrupting = _audioCollection.isPlaying
        _audioCollection.stop()
        if !_audioCollection.next() {
            // last track
            guard _repeatMode == .allRepeat && _audioCollection.setPlayingIndex(0) else {
                // do not or cannot repeat
                notifyPlaylistDidFinish()
                return
            }
        }
        if interrupting {
            _audioCollection.play()
        }
        if let callback = onNextExist {
            callback()
        }
        notifyItemDidChange()
    }

    func prev() {
        let interrupting = _audioCollection.isPlaying
        guard !interrupting || _audioCollection.inBeginning else {
            return _audioCollection.cue()
        }
        _audioCollection.stop()
        if !_audioCollection.prev() {
            // first track
            if _repeatMode != .allRepeat || !_audioCollection.setPlayingIndex(-1) {
                // do not or cannot repeat
                _audioCollection.cue()
            }
        }
        if interrupting {
            _audioCollection.play()
        }
        notifyItemDidChange()
    }
    
    func seek(toTime time: TimeInterval) {
        _audioCollection.seek(toTime: time)
    }

    /*
     * AudioModelDelegate
     */
    func playingAudioDidFinish(successfully flag: Bool) {
        if case .singleRepeat = _repeatMode {
            _audioCollection.cue()
            return _audioCollection.play()
        }
        next { self._audioCollection.play() }
    }
    
    func playingAudioDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        _delegate.playingItemDidElapse(currentTime: currentTime, wholeDuration: wholeDuration)
    }

    /*
     * RemoteControlModelDelegate
     */
    func didReceivePlay() {
        _audioCollection.play()
        _delegate.didPlayAutomatically()
    }

    func didReceivePause() {
        _audioCollection.pause()
        _delegate.didPauseAutomatically()
    }

    func didReceiveTogglePlay() {
        if _audioCollection.isPlaying {
            _audioCollection.pause()
            _delegate.didPauseAutomatically()
        } else {
            _audioCollection.play()
            _delegate.didPlayAutomatically()
        }
    }

    func didReceiveNext() {
        next()
    }

    func didReceivePrev() {
        prev()
    }
    
    func didSeekStepForward() {
        _audioCollection.seek(bySeconds: 5, toForward: true)
    }
    
    func didSeekStepBackward() {
        _audioCollection.seek(bySeconds: 5, toForward: false)
    }

    /*
     * Helper methods
     */
    private func notifyItemDidChange() {
        let info = AudioInfoModel(ofItem: _audioCollection.playingItem)
        _remoteControl.updateNowPlayingInfo(withInfo: info)
        _delegate.playingItemDidChange(info: info)
    }
    
    private func notifyPlaylistDidFinish() {
        _remoteControl.unsetNowPlayingInfo()
        _delegate.playlistDidFinish()
    }
}
