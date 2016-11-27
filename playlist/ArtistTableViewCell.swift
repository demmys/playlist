//
//  ArtistTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class ArtistTableViewCell : UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!

    func setAudioInfo(_ info: AudioInfoModel) {
        artistLabel.text = info.albumArtist
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
    }
}
