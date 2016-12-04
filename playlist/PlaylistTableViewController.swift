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
    private var _playlists: [MPMediaPlaylist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _playlists = MPMediaQuery.playlists().collections as! [MPMediaPlaylist]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        let playlist = _playlists[indexPath.row]
        cell.setPlaylistInfo(playlist)
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showPlaylistSongsSegue" && self.tableView.indexPathForSelectedRow == nil {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showPlaylistSongsSegue":
            guard let receiver = segue.destination as? PlaylistSongTableViewController else {
                return
            }
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            receiver.setPlaylist(_playlists[selectedPath.row])
        default:
            break
        }
    }
}
