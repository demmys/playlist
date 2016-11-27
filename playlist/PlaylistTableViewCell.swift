//
//  PlaylistTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class PlaylistTableViewCell : UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func setAudioInfo(_ info: AudioInfoModel) {
        titleLabel.text = info.playlist
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
    }
}
