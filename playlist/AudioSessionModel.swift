//
//  AudioSessionModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/03.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import AVFoundation

class AudioSessionModel {
    private var _categoryDidSet: Bool = false
    private var _isActive: Bool = false

    init() {
        tryToSetCategory()
    }

    func activate() {
        guard !_isActive else {
            return
        }
        tryToSetCategory()
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            _isActive = true
        } catch {}
    }

    func deactivate() {
        guard _isActive else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            _isActive = false
        } catch {}
    }

    private func tryToSetCategory() {
        guard !_categoryDidSet else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            _categoryDidSet = true
        } catch {}
    }
}
