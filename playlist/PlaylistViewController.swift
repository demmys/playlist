//
//  PlaylistViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/12.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController : UITableViewController, PlaylistManagerModelDelegate {
    private enum EditingStatus {
        case listing
        case editing
    }
    static let EDIT_BUTTON_TEXT_EDIT = "edit"
    static let EDIT_BUTTON_TEXT_DONE = "done"

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    private var _status: EditingStatus = .listing
    private var _items: [MPMediaItem] = []
    private var _index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.target = self
        doneButton.action = #selector(doneButtonDidTouch)
        editButton.target = self
        editButton.action = #selector(editButtonDidTouch)
        updatePlayingInfo()

        if let playlist = PlayerService.shared.playlist {
            playlist.addDelegate(self)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistViewCell
        let info = AudioInfoModel(ofItem: _items[indexPath.row])
        cell.setAudioInfo(info)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == _index {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == _index {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _ = PlayerService.shared.moveSong(from: sourceIndexPath.row, to: destinationIndexPath.row)
        updatePlayingInfo()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        _ = PlayerService.shared.deleteSong(at: indexPath.row)
        updatePlayingInfo()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    /*
     * PlaylistManagerModelDelegate
     */
    func playingItemDidChange(info: AudioInfoModel) {
        updatePlayingIndex()
    }

    func playingItemDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {}

    func playlistDidFinish() {
        dismiss()
    }

    func didPlay() {}

    func didPause() {}

    /*
     * Interface Builder callbacks
     */
    @objc func doneButtonDidTouch(_ sender: AnyObject) {
        dismiss()
    }
    
    @objc func editButtonDidTouch(_ sender: AnyObject) {
        switch _status {
        case .listing:
            _status = .editing
            editButton.title = PlaylistViewController.EDIT_BUTTON_TEXT_DONE
            doneButton.isEnabled = false
            tableView.setEditing(true, animated: true)
        case .editing:
            _status = .listing
            editButton.title = PlaylistViewController.EDIT_BUTTON_TEXT_EDIT
            doneButton.isEnabled = true
            tableView.setEditing(false, animated: true)
        }
    }
    
    /*
     * Helper methods
     */
    private func updatePlayingInfo() {
        updatePlayingIndex()
        updatePlaylistItems()
    }

    private func updatePlayingIndex() {
        guard let index = PlayerService.shared.playlist?.playingIndex else {
            return
        }
        _index = index
    }
    
    private func updatePlaylistItems() {
        guard let items = PlayerService.shared.playlist?.items else {
            return
        }
        _items = items
    }

    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
