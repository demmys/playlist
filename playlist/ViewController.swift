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
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!

    private var _audioSession: AudioSessionModel!
    private var _pickerFactory: PickerFactory!
    private var _playlist: PlaylistModel?
    private var _seeking: Bool = false

    /*
     * Lifecycle callbacks
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        unsetSongInformation()

        selectButton.addTarget(self, action: #selector(selectButtonDidTouch), for: .touchUpInside)
        controlButton.addTarget(self, action: #selector(controlButtonDidTouch), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTouch), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevButtonDidTouch), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekSliderValueDidChange), for: .valueChanged)
        seekSlider.addTarget(self, action: #selector(seekSliderWillBeginSeek), for: .touchDown)
        seekSlider.addTarget(self, action: #selector(seekSliderDidEndSeek), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekSliderDidEndSeek), for: .touchUpOutside)

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
    
    @objc func seekSliderWillBeginSeek(_ sender: AnyObject) {
        _seeking = true
    }
    
    @objc func seekSliderDidEndSeek(_ sender: AnyObject) {
        _playlist?.seek(toTime: TimeInterval(seekSlider.value))
        _seeking = false
    }
    
    @objc func seekSliderValueDidChange(_ sender: AnyObject) {
        guard let playlist = _playlist else {
            return
        }
        let currentTime = seekSlider.value
        let wholeDuration = playlist.playingItem.playbackDuration
        updateSeekLabel(withCurrentSeconds: detailedTimeToSeconds(currentTime), ofWholeSeconds: detailedTimeToSeconds(wholeDuration))
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
    func playingItemDidChange(info: AudioInfoModel) {
        updateSongInformation(withInfo: info)
        seekSlider.maximumValue = Float(info.duration)
        updateSeekInformation(withCurrentTime: 0, ofWholeDuration: info.duration)
    }
    
    func playingItemDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {
        if _seeking {
            return
        }
        updateSeekInformation(withCurrentTime: currentTime, ofWholeDuration: wholeDuration)
    }

    func playlistDidFinish() {
        _playlist = nil
        unsetSongInformation()
        unsetSeekInformation()
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
            controlButton.setTitle(ViewController.BUTTON_TEXT_PAUSE, for: .normal)
        } else {
            controlButton.setTitle(ViewController.BUTTON_TEXT_PLAY, for: .normal)
        }
    }

    private func unsetSongInformation() {
        let info = AudioInfoModel()
        artistLabel.text = info.artist
        titleLabel.text = info.title
        albumLabel.text = info.album
        artworkView.image = nil
    }

    private func updateSongInformation(withInfo info: AudioInfoModel) {
        artistLabel.text = info.artist
        titleLabel.text = info.title
        albumLabel.text = info.album
        if let artwork = info.artwork {
            artworkView.image = artwork.image(at: artworkView.bounds.size)
        } else {
            artworkView.image = nil
        }
    }
    
    private func unsetSeekInformation() {
        elapsedTimeLabel.text = "-:--"
        remainingTimeLabel.text = "-:--"
        seekSlider.setValue(0, animated: false)
        seekSlider.isEnabled = false
    }
    
    private func updateSeekInformation(withCurrentTime currentTime: TimeInterval, ofWholeDuration wholeDuration: TimeInterval) {
        updateSeekLabel(withCurrentSeconds: detailedTimeToSeconds(currentTime), ofWholeSeconds: detailedTimeToSeconds(wholeDuration))
        seekSlider.setValue(Float(currentTime), animated: true)
        if !seekSlider.isEnabled {
            seekSlider.isEnabled = true
        }
    }
    
    private func updateSeekLabel(withCurrentSeconds currentSeconds: Int, ofWholeSeconds wholeSeconds: Int) {
        elapsedTimeLabel.text = secondsToMinutesSecondsString(currentSeconds)
        remainingTimeLabel.text = "-\(secondsToMinutesSecondsString(wholeSeconds - currentSeconds))"
    }
    
    /*
     * Helper methods
     */
    private func detailedTimeToSeconds(_ time: TimeInterval) -> Int {
        return Int(ceil(time))
    }
    private func detailedTimeToSeconds(_ time: Float) -> Int {
        return Int(ceil(time))
    }
    
    private func secondsToMinutesSecondsString(_ seconds: Int) -> String {
        let secPart = seconds % 60
        let minPart = seconds / 60
        return String(format: "%d:%02d", minPart, secPart)
    }
}

