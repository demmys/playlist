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
    private let _delegate: AudioModelDelegate
    
    var isPlaying: Bool {
        get { return _player.isPlaying }
    }

    init?(withItem item: MPMediaItem, playSoon: Bool, delegate: AudioModelDelegate) {
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
            _player.prepareToPlay()
        }
    }
    
    func play(withDelay delay: TimeInterval = 0) {
        if delay > 0 {
            _player.play(atTime: _player.deviceCurrentTime + delay)
        } else {
            _player.play()
        }
    }
    
    func pause() {
        _player.pause()
    }
    
    func stop() {
        // TODO: fade out option
        _player.stop()
    }
    
    func begin() {
        _player.currentTime = 0.0
        _player.play()
    }
    
    func seek(toTime target: TimeInterval) {
        _player.currentTime = target
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        _delegate.playingAudioDidFinish(successfully: flag)
    }
}