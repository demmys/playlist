//
//  ViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, PickerFactoryDelegate, PlaylistModelDelegate {
    private static let BUTTON_TEXT_PLAY = "▶"
    private static let BUTTON_TEXT_PAUSE = "ⅠⅠ"

    // Interface Builder objects
    @IBOutlet weak var _selectButton: UIButton!
    @IBOutlet weak var _controlButton: UIButton!
    @IBOutlet weak var _prevButton: UIButton!
    @IBOutlet weak var _nextButton: UIButton!
    @IBOutlet weak var _artworkView: UIImageView!
    @IBOutlet weak var _albumLabel: UILabel!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _artistLabel: UILabel!

    private var _audioSession: AudioSessionModel!
    private var _pickerFactory: PickerFactory!
    private var _playlist: PlaylistModel?

    /*
     * Lifecycle callbacks
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        unsetSongInformation()

        _selectButton.addTarget(self, action: #selector(selectButtonDidTouch), for: .touchUpInside)
        _controlButton.addTarget(self, action: #selector(controlButtonDidTouch), for: .touchUpInside)
        _nextButton.addTarget(self, action: #selector(nextButtonDidTouch), for: .touchUpInside)
        _prevButton.addTarget(self, action: #selector(prevButtonDidTouch), for: .touchUpInside)

        _audioSession = AudioSessionModel()
        _pickerFactory = PickerFactory(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        _playlist?.releaseCache()
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
            presentInformationAlert(message: "まずは再生する音楽を選択してください。")
            return
        }
        if playlist.togglePlay() {
            _audioSession.activate()
            updateControlButtonView(playing: true)
        } else {
            updateControlButtonView(playing: false)
        }
    }

    @objc func nextButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            presentInformationAlert(message: "まずは再生する音楽を選択してください。")
            return
        }
        playlist.next()
    }

    @objc func prevButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            presentInformationAlert(message: "まずは再生する音楽を選択してください。")
            return
        }
        playlist.prev()
    }

    /*
     * PickerModelDelegate
     */
    func didPickFinish(collection: MPMediaItemCollection) {
        var interrupting = false
        if let oldPlaylist = _playlist, oldPlaylist.isPlaying {
            interrupting = true
            _playlist = nil
        }
        _playlist = PlaylistModel(withItems: collection.items, startIndex: 0, delegate: self, playNow: interrupting)
        dismissPicker()
    }

    func didPickCancel() {
        dismissPicker()
    }

    /*
     * PlaylistModelDelegate
     */
    func playingItemDidChange(_ info: AudioInfoModel) {
        updateSongInformation(withInfo: info)
    }

    func playlistDidFinish() {
        _playlist = nil
        unsetSongInformation()
        updateControlButtonView(playing: false)
        _audioSession.deactivate()
    }

    func didPlayAutomatically() {
        updateControlButtonView(playing: true)
    }

    func didPauseAutomatically() {
        updateControlButtonView(playing: false)
    }

    /*
     * View control methods
     */
    private func presentInformationAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func presentPicker() {
        present(_pickerFactory.build(), animated: true, completion: nil)
    }

    private func dismissPicker() {
        dismiss(animated: true, completion: nil)
    }

    private func updateControlButtonView(playing: Bool) {
        if playing {
            _controlButton.setTitle(ViewController.BUTTON_TEXT_PAUSE, for: .normal)
        } else {
            _controlButton.setTitle(ViewController.BUTTON_TEXT_PLAY, for: .normal)
        }
    }

    private func unsetSongInformation() {
        let info = AudioInfoModel()
        _artistLabel.text = info.artist
        _titleLabel.text = info.title
        _albumLabel.text = info.album
        _artworkView.image = nil
    }

    private func updateSongInformation(withInfo info: AudioInfoModel) {
        _artistLabel.text = info.artist
        _titleLabel.text = info.title
        _albumLabel.text = info.album
        if let artwork = info.artwork {
            _artworkView.image = artwork.image(at: _artworkView.bounds.size)
        } else {
            _artworkView.image = nil
        }
    }
}

