//
//  PlaylistSongTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class PlaylistSongTableViewCell : UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var addPlaylistButton: UIButton!

    func setAudioInfo(_ info: AudioInfoModel) {
        titleLabel.text = info.title
        artistLabel.text = info.artist
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
    }
}
