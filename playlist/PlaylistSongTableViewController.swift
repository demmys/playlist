//
//  PlaylistSongTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/04.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistSongTableViewController : UITableViewController {
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addPlaylistButton: UIButton!
    
    private var _playlist: MPMediaPlaylist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = _playlist.name
        if let artwork = _playlist.representativeItem?.artwork {
            artworkImage.image = artwork.image(at: artworkImage.bounds.size)
        } else {
            artworkImage.image = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _playlist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistSongCell", for: indexPath) as! PlaylistSongTableViewCell
        let info = AudioInfoModel(ofItem: _playlist.items[indexPath.row])
        cell.setAudioInfo(info)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didStartPlaylist"), object: nil, userInfo: nil)
    }

    func setPlaylist(_ playlist: MPMediaPlaylist) {
        _playlist = playlist
    }
}
