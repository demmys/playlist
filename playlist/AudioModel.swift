//
//  AudioModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/29.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioModel : NSObject, AVAudioPlayerDelegate {
    private let _player: AVAudioPlayer
    private weak var _delegate: AudioModelDelegate!
    private var _progressTimer: Timer?
    private var _operationQueue: OperationQueue?

    var isPlaying: Bool {
        return _player.isPlaying
    }

    var inBeginning: Bool {
        return _player.currentTime < 5
    }
    
    var currentTime: TimeInterval {
        return _player.currentTime
    }
    
    var duration: TimeInterval {
        return _player.duration
    }
    
    var remains: TimeInterval {
        return _player.duration - _player.currentTime
    }

    init?(withItem item: MPMediaItem, playSoon: Bool, withDelegate delegate: AudioModelDelegate) {
        guard let url = item.value(forKey: MPMediaItemPropertyAssetURL) as? URL else {
            return nil
        }
        do {
            _player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return nil
        }
        _delegate = delegate
        super.init()
        _player.delegate = self
        if !playSoon {
            let queue = OperationQueue()
            queue.addOperation {
                self._player.prepareToPlay()
            }
            _operationQueue = queue
        }
    }
    
    deinit {
        _operationQueue?.cancelAllOperations()
    }
    
    /*
     * AVAudioPlayerDelegate
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        endNotifyingPlayingAudioDidElapseEvent()
        _delegate.playingAudioDidFinish()
    }

    /*
     * Audio control methods
     */
    func play(withDelay delay: TimeInterval = 0) {
        if delay > 0 {
            _player.play(atTime: _player.deviceCurrentTime + delay)
        } else {
            _player.play()
        }
        beginNotifyingPlayingAudioDidElapseEvent()
    }

    func pause() {
        _player.pause()
        endNotifyingPlayingAudioDidElapseEvent()
    }

    func stop() {
        _player.stop()
        _player.currentTime = 0.0
        endNotifyingPlayingAudioDidElapseEvent()
    }

    func cue() {
        _player.currentTime = 0.0
    }

    func seek(toTime time: TimeInterval) {
        _player.currentTime = time
    }
    func seek(bySeconds seconds: Int, toForward forwarding: Bool) {
        if forwarding {
            _player.currentTime += TimeInterval(seconds)
        } else {
            _player.currentTime -= TimeInterval(seconds)
        }
    }
    
    private func beginNotifyingPlayingAudioDidElapseEvent() {
        _progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self._delegate.playingAudioDidElapse(sender: self)
        }
    }
    
    private func endNotifyingPlayingAudioDidElapseEvent() {
        _progressTimer?.invalidate()
        _progressTimer = nil
    }
}
