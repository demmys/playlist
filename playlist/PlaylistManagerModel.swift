//
//  PlaylistManagerModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/29.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PlaylistManagerModel : PlaylistModelDelegate, RemoteControlModelDelegate {
    enum ShuffleMode {
        case noShuffle
        case allShuffle
    }

    private weak var _delegate: PlaylistManagerModelDelegate!
    private var _playlist: PlaylistModel!
    private var _remoteControl: RemoteControlModel!
    private var _shuffleMode: ShuffleMode = .noShuffle

    var playingItem: MPMediaItem {
        get { return _playlist.playingItem }
    }
    
    var isPlaying: Bool {
        get { return _playlist.isPlaying }
    }

    init?(withItems items: [MPMediaItem], startIndex: Int, delegate: PlaylistManagerModelDelegate, playNow: Bool) {
        guard let audioCollection = PlaylistModel(withItems: items, startIndex: startIndex, withDelegate: self) else {
            return nil
        }
        _delegate = delegate
        _playlist = audioCollection
        _remoteControl = RemoteControlModel(delegate: self)
        notifyItemDidChange()
        if playNow {
            _playlist.play()
            _delegate.didPlayAutomatically()
        }
    }

    deinit {
        if _playlist.isPlaying {
            _playlist.stop()
            _delegate.didPauseAutomatically()
        }
    }

    func setRepeatMode(_ mode: RepeatMode) {
        _playlist.repeatMode = mode
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
        if _playlist.isPlaying {
            _playlist.pause()
            return false
        }
        _playlist.play()
        return true
    }

    func next() {
        if _playlist.next() {
            notifyItemDidChange()
        } else {
            notifyPlaylistDidFinish()
        }
    }

    func prev() {
        if (_playlist.isPlaying && !_playlist.inBeginning) || !_playlist.prev() {
            _playlist.cue()
        }
        notifyItemDidChange()
    }
    
    func seek(toTime time: TimeInterval) {
        _playlist.seek(toTime: time)
    }

    /*
     * PlaylistModelDelegate
     */
    func playingAudioDidChangeAutomatically(changedTo item: MPMediaItem) {
        notifyItemDidChange()
    }
    
    func playingAudioDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        _delegate.playingItemDidElapse(currentTime: currentTime, wholeDuration: wholeDuration)
    }
    
    func playingAudioDidFinishAutomatically() {
        notifyPlaylistDidFinish()
    }

    /*
     * RemoteControlModelDelegate
     */
    func didReceivePlay() {
        _playlist.play()
        _delegate.didPlayAutomatically()
    }

    func didReceivePause() {
        _playlist.pause()
        _delegate.didPauseAutomatically()
    }

    func didReceiveTogglePlay() {
        if _playlist.isPlaying {
            _playlist.pause()
            _delegate.didPauseAutomatically()
        } else {
            _playlist.play()
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
        _playlist.seek(bySeconds: 5, toForward: true)
    }
    
    func didSeekStepBackward() {
        _playlist.seek(bySeconds: 5, toForward: false)
    }

    /*
     * Helper methods
     */
    private func notifyItemDidChange() {
        let info = AudioInfoModel(ofItem: _playlist.playingItem)
        _remoteControl.updateNowPlayingInfo(withInfo: info)
        _delegate.playingItemDidChange(info: info)
    }
    
    private func notifyPlaylistDidFinish() {
        _remoteControl.unsetNowPlayingInfo()
        _delegate.playlistDidFinish()
    }
}
