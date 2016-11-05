//
//  CachedAudioModelCollectionDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/05.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

protocol CachedAudioModelCollectionDelegate : class {
    func playingAudioDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval)
    func playingAudioDidChangeAutomatically(changedTo item: MPMediaItem)
    func playingAudioDidFinishAutomatically()
}
