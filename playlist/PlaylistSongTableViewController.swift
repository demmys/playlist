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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showPlayerSegue":
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            PlayerService.shared.startPlaylist(ofItems: _playlist.items, startIndex: selectedPath.row)
        default:
            break
        }
    }
    
    func setPlaylist(_ playlist: MPMediaPlaylist) {
        _playlist = playlist
    }
}
