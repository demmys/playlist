//
//  AlbumSongTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class AlbumSongTableViewCell : PlaylistAddableSongTableViewCell {
    @IBOutlet weak var trackNoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addPlaylistButton: UIButton!
    
    func setup(info: AudioInfoModel, alertBuilder: AlertBuilder) {
        trackNoLabel.text = String(info.trackNo)
        titleLabel.text = info.title
        super.setup(info: info, alertBuilder: alertBuilder, addPlaylistButton: addPlaylistButton)
    }
}
