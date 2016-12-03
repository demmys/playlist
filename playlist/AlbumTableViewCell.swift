//
//  AlbumTableViewCell.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/24.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import UIKit

class AlbumTableViewCell : UITableViewCell {
    @IBOutlet weak var leftArtworkImage: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftArtistLabel: UILabel!
    @IBOutlet weak var rightArtworkImage: UIImageView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightArtistLabel: UILabel!

    private var _leftAudioInfo: AudioInfoModel!
    private var _rightAudioInfo: AudioInfoModel?
    var onArtworkDidTap: ((UIView, AudioInfoModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftArtworkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftArtworkDidTap)))
        rightArtworkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightArtworkDidTap)))
    }
    
    func leftArtworkDidTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        guard let callback = onArtworkDidTap else {
            return
        }
        callback(leftArtworkImage, _leftAudioInfo)
    }
    
    func rightArtworkDidTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        guard let callback = onArtworkDidTap else {
            return
        }
        guard let info = _rightAudioInfo else {
            return
        }
        callback(rightArtworkImage, info)
    }
    
    func setAudioInfo(first: AudioInfoModel, second: AudioInfoModel?) {
        _leftAudioInfo = first
        _rightAudioInfo = second

        leftTitleLabel.text = first.album
        leftArtistLabel.text = first.hasAlbumArtist ? first.albumArtist : first.artist
        leftArtworkImage.image = first.artworkImage(ofSize: leftArtworkImage.bounds.size)
        if let secondInfo = second {
            rightTitleLabel.text = secondInfo.album
            rightArtistLabel.text = secondInfo.hasAlbumArtist ? secondInfo.albumArtist : secondInfo.artist
            rightArtworkImage.image = secondInfo.artworkImage(ofSize: rightArtworkImage.bounds.size)
        } else {
            rightTitleLabel.text = ""
            rightArtistLabel.text = ""
            rightArtworkImage.image = nil
        }
    }
}
