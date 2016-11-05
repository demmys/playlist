//
//  PlaylistManagerModelDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/30.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

protocol PlaylistManagerModelDelegate : class {
    func playingItemDidChange(info: AudioInfoModel)
    func playingItemDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval)
    func playlistDidFinish()
    func didPlayAutomatically()
    func didPauseAutomatically()
}
