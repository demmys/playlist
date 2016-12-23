//
//  PlaylistViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/12.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController : UITableViewController, UINavigationBarDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    private var _items: [MPMediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.target = self
        doneButton.action = #selector(doneButtonDidTouch)
        guard let items = PlayerService.shared.playlist?.items else {
            return
        }
        _items = items
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
    
    /*
     * UINavigationBarDelegate
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }
    
    /*
     * Interface Builder callbacks
     */
    @objc func doneButtonDidTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
