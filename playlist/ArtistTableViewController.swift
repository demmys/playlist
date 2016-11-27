//
//  ArtistTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistTableViewController : UITableViewController {
    private var _audioInfoList: AudioInfoListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _audioInfoList = AudioInfoListModel(fromQuery: MediaQueryBuilder.artists())
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return _audioInfoList.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _audioInfoList.itemCountOfSection(atIndex: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return _audioInfoList.indexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _audioInfoList.indexTitles?[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! ArtistTableViewCell
        let info = _audioInfoList.get(inSection: indexPath.section, index: indexPath.row)
        cell.setAudioInfo(info)
        return cell
    }
}
