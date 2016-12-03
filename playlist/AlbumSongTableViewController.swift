//
//  AlbumSongTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumSongTableViewController : UITableViewController {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!

    private var _audioInfoList: AudioInfoSectionedListModel!
    private var _representiveInfo: AudioInfoModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        artworkImage.image = _representiveInfo.artworkImage(ofSize: artworkImage.bounds.size)
        titleLabel.text = _representiveInfo.album
        artistLabel.text = _representiveInfo.albumArtist
        detailInfoLabel.text = _representiveInfo.genre
        let query = MediaQueryBuilder.songs(inAlbum: _representiveInfo.album, ofArtist: _representiveInfo.albumArtist)
        _audioInfoList = AudioInfoSectionedListModel(fromQuery: query, sortByProperties: [MPMediaItemPropertyDiscNumber, MPMediaItemPropertyAlbumTrackNumber], usingConverter: { $0 as? Int })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _audioInfoList.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongCell", for: indexPath) as! AlbumSongTableViewCell
        let info = _audioInfoList.get(atIndex: indexPath.row)
        cell.setAudioInfo(info)
        return cell
    }
    
    func setAlbumRepresentiveInfo(_ info: AudioInfoModel) {
        _representiveInfo = info
    }
}
