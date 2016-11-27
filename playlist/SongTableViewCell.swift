//
//  SongTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/06.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class SongTableViewCell : UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!

    func setAudioInfo(_ info: AudioInfoModel) {
        titleLabel.text = info.title
        artistLabel.text = info.artist
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
    }
}
