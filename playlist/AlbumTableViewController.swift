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
        let (firstInfo, secondInfo) = _audioInfoList.getPair(inSection: indexPath.section, index: indexPath.row)
        cell.setAudioInfo(first: firstInfo, second: secondInfo)
        cell.onArtworkDidTap = onArtworkDidTap
        return cell
    }
    
    private func onArtworkDidTap(sender: UIView, tartgetInfo: AudioInfoModel) {
        performSegue(withIdentifier: "showAlbum", sender: sender)
    }
}
