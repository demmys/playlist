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
        let center = MPRemoteCommandCenter.shared()
        center.togglePlayPauseCommand.addTarget(self, action: #selector(didReceiveTogglePlayPauseCommand))
        center.playCommand.addTarget(self, action: #selector(didReceivePlayCommand))
        center.pauseCommand.addTarget(self, action: #selector(didReceivePauseCommand))
        center.nextTrackCommand.addTarget(self, action: #selector(didReceiveNextTrackCommand))
        center.previousTrackCommand.addTarget(self, action: #selector(didReceivePreviousTrackCommand))
    }

    deinit {
        let center = MPRemoteCommandCenter.shared()
        center.togglePlayPauseCommand.removeTarget(self)
        center.playCommand.removeTarget(self)
        center.pauseCommand.removeTarget(self)
        center.nextTrackCommand.removeTarget(self)
        center.previousTrackCommand.removeTarget(self)
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
