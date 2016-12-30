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
    private var _alertBuilder: AlertBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = _playlist.name
        if let artwork = _playlist.representativeItem?.artwork {
            artworkImage.image = artwork.image(at: artworkImage.bounds.size)
        } else {
            artworkImage.image = nil
        }
        addPlaylistButton.addTarget(self, action: #selector(addPlaylistButtonDidTouch), for: .touchUpInside)
        _alertBuilder = AlertBuilder(presentingViewController: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _playlist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistSongCell", for: indexPath) as! PlaylistSongTableViewCell
        let info = AudioInfoModel(ofItem: _playlist.items[indexPath.row])
        cell.setup(info: info, alertBuilder: _alertBuilder)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerService.shared.startPlaylist(ofItems: _playlist.items, startIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setPlaylist(_ playlist: MPMediaPlaylist) {
        _playlist = playlist
    }
    
    /*
     * Interface Builder callbacks
     */
    @objc func addPlaylistButtonDidTouch(_ sender: AnyObject) {
        _alertBuilder?.presentAddPlaylistAlert(title: _playlist.name, items: _playlist.items)
    }
}
