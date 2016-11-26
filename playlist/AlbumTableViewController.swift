//
//  AlbumTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/24.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumTableViewController : UITableViewController {
    private var _audioInfoList: AudioInfoListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _audioInfoList = AudioInfoListModel(fromQuery: MediaQueryBuilder.albums())
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return _audioInfoList.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _audioInfoList.pairedItemCountOfSection(atIndex: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return _audioInfoList.indexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _audioInfoList.indexTitles?[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        let infoPair = _audioInfoList.getPair(inSection: indexPath.section, index: indexPath.row)
        setAudioInfo(infoPair, toCell: cell)
        return cell
    }
    
    private func setAudioInfo(_ infoPair: (AudioInfoModel, AudioInfoModel?), toCell cell: AlbumTableViewCell) {
        cell.leftTitleLabel.text = infoPair.0.album
        cell.leftArtistLabel.text = infoPair.0.artist
        cell.leftArtworkImage.image = infoPair.0.artworkImage(ofSize: cell.leftArtworkImage.bounds.size)
        if let secondInfo = infoPair.1 {
            cell.rightTitleLabel.text = secondInfo.album
            cell.rightArtistLabel.text = secondInfo.artist
            cell.rightArtworkImage.image = secondInfo.artworkImage(ofSize: cell.rightArtworkImage.bounds.size)
        } else {
            cell.rightTitleLabel.text = ""
            cell.rightArtistLabel.text = ""
            cell.rightArtworkImage.image = nil
        }
    }
}
