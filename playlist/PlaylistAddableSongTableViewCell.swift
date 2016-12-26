//
//  PlaylistAddableSongTableViewCell.swift
//  playlist
//
//  Created by 出水　厚輝 on 2016/12/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class PlaylistAddableSongTableViewCell : UITableViewCell {
    private var _info: AudioInfoModel?
    private weak var _alertBuilder: AlertBuilder?
    
    func setup(info: AudioInfoModel, alertBuilder: AlertBuilder, addPlaylistButton: UIButton) {
        _info = info
        _alertBuilder = alertBuilder
        addPlaylistButton.addTarget(self, action: #selector(addPlaylistButtonDidTouch), for: .touchUpInside)
    }
    
    /*
     * Interface Builder callbacks
     */
    @objc func addPlaylistButtonDidTouch(_ sender: AnyObject) {
        guard let item = _info?.originalItem else {
            return
        }
        _alertBuilder?.presentAddPlaylistAlert(title: _info?.title, items: [item])
    }
}
