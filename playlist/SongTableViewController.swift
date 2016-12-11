//
//  SongTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/06.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController : UITableViewController {
    private var _audioInfoList: AudioInfoSectionedListModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        _audioInfoList = AudioInfoSectionedListModel(fromQuery: MediaQueryBuilder.songs())
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        let info = _audioInfoList.get(inSection: indexPath.section, index: indexPath.row)
        cell.setAudioInfo(info)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showPlayerSegue":
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            PlayerService.shared.startPlaylist(ofItems: _audioInfoList.getMediaItemArray(atIndex: selectedPath.row), startIndex: 0)
        default:
            break
        }
    }
}
