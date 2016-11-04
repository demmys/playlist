//
//  PlaylistModelDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/30.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

protocol PlaylistModelDelegate : class {
    func playingItemDidChange(_ info: AudioInfoModel)
    func playlistDidFinish()
    func didPlayAutomatically()
    func didPauseAutomatically()
}
