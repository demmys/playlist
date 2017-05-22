//
//  Music.swift
//  playlist
//
//  Created by 出水　厚輝 on 2017/05/21.
//  Copyright © 2017年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class Music {
    private let _original: MPMediaItem?
    
    init(withItem item: MPMediaItem? = nil) {
        _original = item
    }
}
