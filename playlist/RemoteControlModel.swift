//
//  RemoteControlModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/03.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class RemoteControlModel : NSObject {
    private weak var _delegate: RemoteControlModelDelegate!

    init(delegate: RemoteControlModelDelegate) {
        super.init()
        _delegate = delegate
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(didReceiveTogglePlayPauseCommand))
        remoteCommandCenter.playCommand.addTarget(self, action: #selector(didReceivePlayCommand))
        remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(didReceivePauseCommand))
        remoteCommandCenter.nextTrackCommand.addTarget(self, action: #selector(didReceiveNextTrackCommand))
        remoteCommandCenter.previousTrackCommand.addTarget(self, action: #selector(didReceivePreviousTrackCommand))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(audioSessionRouteDidChange), name: .AVAudioSessionRouteChange, object: nil)
        notificationCenter.addObserver(self, selector: #selector(audioSessionDidInterrupt), name: .AVAudioSessionInterruption, object: nil)
    }

    deinit {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        remoteCommandCenter.togglePlayPauseCommand.removeTarget(self)
        remoteCommandCenter.playCommand.removeTarget(self)
        remoteCommandCenter.pauseCommand.removeTarget(self)
        remoteCommandCenter.nextTrackCommand.removeTarget(self)
        remoteCommandCenter.previousTrackCommand.removeTarget(self)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didReceivePlayCommand(event: MPRemoteCommandEvent) {
        _delegate.didReceivePlay()
    }

    @objc func didReceivePauseCommand(event: MPRemoteCommandEvent) {
        _delegate.didReceivePause()
    }

    @objc func didReceiveTogglePlayPauseCommand(event: MPRemoteCommandEvent) {
        _delegate.didReceiveTogglePlay()
    }

    @objc func didReceiveNextTrackCommand(event: MPRemoteCommandEvent) {
        _delegate.didReceiveNext()
    }

    @objc func didReceivePreviousTrackCommand(event: MPRemoteCommandEvent) {
        _delegate.didReceivePrev()
    }
    
    @objc func audioSessionRouteDidChange(notification: NSNotification) {
        let reasonNo = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber
        guard let no = reasonNo, let reason = AVAudioSessionRouteChangeReason(rawValue: no.uintValue) else {
            _delegate.didReceivePause()
            return
        }
        switch reason {
        case .oldDeviceUnavailable:
            _delegate.didReceivePause()
        default:
            break
        }
    }
    
    @objc func audioSessionDidInterrupt(notification: NSNotification) {
        let typeNo = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber
        guard let no = typeNo, let type = AVAudioSessionInterruptionType(rawValue: no.uintValue) else {
            _delegate.didReceivePause()
            return
        }
        switch type {
        case .began:
            _delegate.didReceivePause()
        case .ended:
            _delegate.didReceivePlay()
        }
    }

    func updateNowPlayingInfo(withInfo info: AudioInfoModel) {
        var nowPlayingInfo: [String : Any] = [
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyAlbumTitle: info.album
        ]
        if let artwork = info.artwork {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func unsetNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
