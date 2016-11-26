//
//  PlaylistTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistTableViewController : UITableViewController {
    private var _audioInfoList: AudioInfoListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _audioInfoList = AudioInfoListModel(fromQuery: MediaQueryBuilder.playlist())
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _audioInfoList.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        let info = _audioInfoList.get(inSection: indexPath.section, index: indexPath.row)
        setAudioInfo(info, toCell: cell)
        return cell
    }
    
    private func setAudioInfo(_ info: AudioInfoModel, toCell cell: PlaylistTableViewCell) {
        cell.titleLabel.text = info.playlist
        cell.artworkImage.image = info.artworkImage(ofSize: cell.artworkImage.bounds.size)
    }
}
