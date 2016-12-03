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
    private var _audioInfoList: AudioInfoSectionedListModel!
    private var _artist: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let artist = _artist {
            let query = MediaQueryBuilder.albums(ofArtist: artist)
            _audioInfoList = AudioInfoSectionedListModel(fromQuery: query, sortByProperties: ["year"], usingConverter: { $0 as? Int })
        } else {
            _audioInfoList = AudioInfoSectionedListModel(fromQuery: MediaQueryBuilder.albums())
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if _artist != nil {
            return 1
        }
        return _audioInfoList.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _artist != nil {
            return _audioInfoList.pairedItemCount
        }
        return _audioInfoList.pairedItemCountOfSection(atIndex: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if _artist != nil {
            return nil
        }
        return _audioInfoList.indexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if _artist != nil {
            return nil
        }
        return _audioInfoList.indexTitles?[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        let (firstInfo, secondInfo): (AudioInfoModel, AudioInfoModel?)
        if _artist != nil {
            (firstInfo, secondInfo) = _audioInfoList.getPair(atIndex: indexPath.row)
        } else {
            (firstInfo, secondInfo) = _audioInfoList.getPair(inSection: indexPath.section, index: indexPath.row)
        }
        cell.setAudioInfo(first: firstInfo, second: secondInfo)
        cell.onArtworkDidTap = onArtworkDidTap
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showAlbumSongsSegue":
            guard let receiver = segue.destination as? AlbumSongTableViewController else {
                return
            }
            guard let targetInfo = sender as? AudioInfoModel else {
                return
            }
            receiver.setAlbumRepresentiveInfo(targetInfo)
        default:
            break
        }
    }
    
    func setArtistFilter(_ artist: String) {
        _artist = artist
    }
    
    private func onArtworkDidTap(targetInfo: AudioInfoModel) {
        performSegue(withIdentifier: "showAlbumSongsSegue", sender: targetInfo)
    }
}
