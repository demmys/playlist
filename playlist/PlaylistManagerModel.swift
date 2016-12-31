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

    private var _delegates = PlaylistManagerModelDelegateWeakArray()
    private var _playlist: PlaylistModel!
    private var _audioSession: AudioSessionModel!
    private var _remoteControl: RemoteControlModel!
    private var _shuffleMode: ShuffleMode = .noShuffle
    
    var items: [MPMediaItem] {
        return _playlist.items
    }

    var playingItem: MPMediaItem {
        return _playlist.playingItem
    }
    
    var playingIndex: Int {
        return _playlist.playingIndex
    }
    
    var isPlaying: Bool {
        return _playlist.isPlaying
    }

    init?(withItems items: [MPMediaItem], startIndex: Int) {
        guard let audioCollection = PlaylistModel(withItems: items, startIndex: startIndex, withDelegate: self) else {
            return nil
        }
        _playlist = audioCollection
        _audioSession = AudioSessionModel()
        _remoteControl = RemoteControlModel(delegate: self)
    }

    deinit {
        if _playlist.isPlaying {
            _playlist.stop()
            notifyPause()
        }
    }
    
    func addDelegate(_ delegate: PlaylistManagerModelDelegate) {
        _delegates.append(delegate)
        // notify current playing status to new delegate and others
        notifyItemDidChange()
        if _playlist.isPlaying {
            delegate.didPlay()
        } else {
            delegate.didPause()
        }
    }

    func setRepeatMode(_ mode: RepeatMode) {
        _playlist.repeatMode = mode
    }

    func setShuffleMode(_ mode: ShuffleMode) {
        _shuffleMode = mode
        // TODO: shuffle remaining list
    }
    
    /*
     * Playing list control methods
     */
    func insert(_ items: [MPMediaItem]) {
        _playlist.insert(items)
    }

    func append(_ items: [MPMediaItem]) {
        _playlist.append(items)
    }
    
    func delete(at index: Int) -> Bool {
        return _playlist.delete(at: index)
    }
    
    func move(from: Int, to: Int) -> Bool {
        return _playlist.move(from: from, to: to)
    }

    /*
     * Audio control methods
     */
    func togglePlay() {
        if _playlist.isPlaying {
            _playlist.pause()
            notifyPause()
        } else {
            _playlist.play()
            notifyPlay()
        }
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
    func playingAudioTimeDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        notifyPlayingItemDidElapse(currentTime: currentTime, wholeDuration: wholeDuration)
    }
    
    func playingAudioTimeDidJump(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        _remoteControl.updateElapsedPlaybackTime(currentTime)
    }

    func playingAudioDidChangeAutomatically(changedTo item: MPMediaItem) {
        notifyItemDidChange()
    }
    
    func playingAudioDidFinishAutomatically() {
        notifyPlaylistDidFinish()
    }

    /*
     * RemoteControlModelDelegate
     */
    func didReceivePlay() {
        _playlist.play()
        notifyPlay()
    }

    func didReceivePause() {
        _playlist.pause()
        notifyPause()
    }

    func didReceiveTogglePlay() {
        if _playlist.isPlaying {
            _playlist.pause()
            notifyPause()
        } else {
            _playlist.play()
            notifyPlay()
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
    private func notifyPlay() {
        _audioSession.activate()
        for delegate in _delegates {
            delegate.didPlay()
        }
    }

    private func notifyPause() {
        for delegate in _delegates {
            delegate.didPause()
        }
    }

    private func notifyItemDidChange() {
        let info = AudioInfoModel(ofItem: _playlist.playingItem)
        _remoteControl.updateNowPlayingInfo(withInfo: info)
        for delegate in _delegates {
            delegate.playingItemDidChange(info: info)
        }
    }
    
    private func notifyPlaylistDidFinish() {
        _remoteControl.unsetNowPlayingInfo()
        _audioSession.deactivate()
        for delegate in _delegates {
            delegate.playlistDidFinish()
        }
    }
    
    private func notifyPlayingItemDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        for delegate in _delegates {
            delegate.playingItemDidElapse(currentTime: currentTime, wholeDuration: wholeDuration)
        }
    }
}
