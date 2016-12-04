//
//  PlaylistTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistTableViewCell : UITableViewCell {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func setPlaylistInfo(_ info: MPMediaPlaylist) {
        titleLabel.text = info.name
        if let artwork = info.representativeItem?.artwork {
            artworkImage.image = artwork.image(at: artworkImage.bounds.size)
        } else {
            artworkImage.image = nil
        }
    }
}
