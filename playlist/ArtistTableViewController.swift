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
    private var _audioInfoList: AudioInfoSectionedListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _audioInfoList = AudioInfoSectionedListModel(fromQuery: MediaQueryBuilder.artists())
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
        let info = getAudioInfo(atPath: indexPath)
        cell.setAudioInfo(info)
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showAlbumsSegue" && self.tableView.indexPathForSelectedRow == nil {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showAlbumsSegue":
            guard let receiver = segue.destination as? AlbumTableViewController else {
                return
            }
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            receiver.setArtistFilter(getAudioInfo(atPath: selectedPath).albumArtist)
        default:
            break
        }
    }
    
    private func getAudioInfo(atPath path: IndexPath) -> AudioInfoModel {
        return _audioInfoList.get(inSection: path.section, index: path.row)
    }
}
