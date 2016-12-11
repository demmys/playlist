//
//  AlbumSongTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class AlbumSongTableViewCell : UITableViewCell {
    @IBOutlet weak var trackNoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setAudioInfo(_ info: AudioInfoModel, ofIndex index: Int) {
        trackNoLabel.text = String(info.trackNo)
        titleLabel.text = info.title
    }
}
