//
//  PlaylistModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/29.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistModel : CachedAudioModelCollectionDelegate, RemoteControlModelDelegate {
    enum ShuffleMode {
        case noShuffle
        case allShuffle
    }

    private weak var _delegate: PlaylistModelDelegate!
    private var _audioCollection: CachedAudioModelCollection!
    private var _remoteControl: RemoteControlModel!
    private var _shuffleMode: ShuffleMode = .noShuffle

    var playingItem: MPMediaItem {
        get { return _audioCollection.playingItem }
    }
    
    var isPlaying: Bool {
        get { return _audioCollection.isPlaying }
    }

    init?(withItems items: [MPMediaItem], startIndex: Int, delegate: PlaylistModelDelegate, playNow: Bool) {
        guard let audioCollection = CachedAudioModelCollection(withItems: items, startIndex: startIndex, withDelegate: self) else {
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
        _audioCollection.repeatMode = mode
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

    func next() {
        if _audioCollection.next() {
            notifyItemDidChange()
        } else {
            notifyPlaylistDidFinish()
        }
    }

    func prev() {
        if _audioCollection.prev() {
            notifyItemDidChange()
        } else {
            _audioCollection.cue()
        }
    }
    
    func seek(toTime time: TimeInterval) {
        _audioCollection.seek(toTime: time)
    }

    /*
     * CachedAudioModelCollectionDelegate
     */
    func playingAudioDidChangeAutomatically(changedTo item: MPMediaItem) {
        notifyItemDidChange()
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
