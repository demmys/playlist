//
//  ViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, PickerModelDelegate, PlaylistModelDelegate {
    let BUTTON_TEXT_PLAY = "▶"
    let BUTTON_TEXT_PAUSE = "ⅠⅠ"
    let NO_TEXT = "-"
    
    // Interface Builder objects
    @IBOutlet weak var _selectButton: UIButton!
    @IBOutlet weak var _controlButton: UIButton!
    @IBOutlet weak var _prevButton: UIButton!
    @IBOutlet weak var _nextButton: UIButton!
    @IBOutlet weak var _artworkView: UIImageView!
    @IBOutlet weak var _albumLabel: UILabel!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _artistLabel: UILabel!

    private var _picker: PickerModel!
    private var _playlist: PlaylistModel?

    /*
     * Lifecycle callbacks
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetSongInformation()

        _selectButton.addTarget(self, action: #selector(selectButtonDidTouch), for: .touchUpInside)
        _controlButton.addTarget(self, action: #selector(controlButtonDidTouch), for: .touchUpInside)
        _nextButton.addTarget(self, action: #selector(nextButtonDidTouch), for: .touchUpInside)
        _prevButton.addTarget(self, action: #selector(prevButtonDidTouch), for: .touchUpInside)
        
        _picker = PickerModel(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
     * Interface Builder callbacks
     */
    @objc func selectButtonDidTouch(_ sender: AnyObject) {
        presentPicker()
    }
    
    @objc func controlButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            presentInformationAlert(title: "おしらせ", message: "まずは再生する音楽を選択してください。")
            return
        }
        if playlist.togglePlay() {
            _controlButton.setTitle(BUTTON_TEXT_PAUSE, for: .normal)
        } else {
            _controlButton.setTitle(BUTTON_TEXT_PLAY, for: .normal)
        }
    }
    
    @objc func nextButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            presentInformationAlert(title: "おしらせ", message: "まずは再生する音楽を選択してください。")
            return
        }
        if playlist.next() {
            updateSongInformation(item: playlist.playingItem)
        }
    }

    @objc func prevButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            presentInformationAlert(title: "おしらせ", message: "まずは再生する音楽を選択してください。")
            return
        }
        if playlist.prev() {
            updateSongInformation(item: playlist.playingItem)
        }
    }
    
    /*
     * PickerModelDelegate
     */
    func didPickFinish(collection: MPMediaItemCollection) {
        _playlist = PlaylistModel(withItems: collection.items, startIndex: 0, delegate: self)
        guard let item = _playlist?.playingItem else {
            presentInformationAlert(title: "おしらせ", message: "音楽のセットに失敗しました。")
            return
        }
        updateSongInformation(item: item)
        dismissPicker()
    }
    
    func didPickCancel() {
        dismissPicker()
    }
    
    /*
     * PlaylistModelDelegate
     */
    func playingItemDidChange(_ item: MPMediaItem) {
        updateSongInformation(item: item)
    }

    func playlistDidFinish() {
        resetSongInformation()
    }

    /*
     * View control methods
     */
    private func presentInformationAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func presentPicker() {
        present(_picker.factory(), animated: true, completion: nil)
    }
    
    private func dismissPicker() {
        dismiss(animated: true, completion: nil)
    }

    private func resetSongInformation() {
        _artistLabel.text = NO_TEXT
        _titleLabel.text = NO_TEXT
        _albumLabel.text = NO_TEXT
        _artworkView.image = nil
    }
    
    private func updateSongInformation(item: MPMediaItem) {
        _artistLabel.text = item.artist ?? NO_TEXT
        _titleLabel.text = item.title ?? NO_TEXT
        _albumLabel.text = item.albumTitle ?? NO_TEXT
        if let artwork = item.artwork {
            _artworkView.image = artwork.image(at: _artworkView.bounds.size)
        } else {
            _artworkView.image = nil
        }
    }
}

