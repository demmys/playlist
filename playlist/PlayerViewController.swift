//
//  ViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController, PlaylistManagerModelDelegate {
    private static let BUTTON_TEXT_PLAY = "▶"
    private static let BUTTON_TEXT_PAUSE = "ⅠⅠ"

    // Interface Builder objects
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var playlistButton: UIButton!

    private var _seeking: Bool = false

    /*
     * Lifecycle callbacks
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(closeButtonDidTouch), for: .touchUpInside)
        controlButton.addTarget(self, action: #selector(controlButtonDidTouch), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTouch), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevButtonDidTouch), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekSliderValueDidChange), for: .valueChanged)
        seekSlider.addTarget(self, action: #selector(seekSliderWillBeginSeek), for: .touchDown)
        seekSlider.addTarget(self, action: #selector(seekSliderDidEndSeek), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekSliderDidEndSeek), for: .touchUpOutside)
        playlistButton.addTarget(self, action: #selector(playlistButtonDidTouch), for: .touchUpInside)

        if let playlist = PlayerService.shared.playlist {
            playlist.addDelegate(self)
        }
    }

    /*
     * Interface Builder callbacks
     */
    @objc func closeButtonDidTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @objc func controlButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = PlayerService.shared.playlist else {
            return
        }
        playlist.togglePlay()
    }

    @objc func nextButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = PlayerService.shared.playlist else {
            return
        }
        playlist.next()
    }

    @objc func prevButtonDidTouch(_ sender: AnyObject) {
        guard let playlist = PlayerService.shared.playlist else {
            return
        }
        playlist.prev()
    }
    
    @objc func seekSliderWillBeginSeek(_ sender: AnyObject) {
        _seeking = true
    }
    
    @objc func seekSliderDidEndSeek(_ sender: AnyObject) {
        PlayerService.shared.playlist?.seek(toTime: TimeInterval(seekSlider.value))
        _seeking = false
    }
    
    @objc func seekSliderValueDidChange(_ sender: AnyObject) {
        guard let playlist = PlayerService.shared.playlist else {
            return
        }
        let currentTime = seekSlider.value
        let wholeDuration = playlist.playingItem.playbackDuration
        updateSeekLabel(withCurrentSeconds: detailedTimeToSeconds(currentTime), ofWholeSeconds: detailedTimeToSeconds(wholeDuration))
    }
    
    @objc func playlistButtonDidTouch(_ sender: AnyObject) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "playlistNavigationController") as? UINavigationController else {
            return
        }
        present(controller, animated: true, completion: nil)
    }

    /*
     * PlaylistManagerModelDelegate
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
        PlayerService.shared.finishPlaylist()
        dismiss(animated: true, completion: nil)
    }

    func didPlay() {
        updateControlButtonView(playing: true)
    }

    func didPause() {
        updateControlButtonView(playing: false)
    }

    /*
     * View control methods
     */
    private func updateControlButtonView(playing: Bool) {
        if playing {
            controlButton.setTitle(PlayerViewController.BUTTON_TEXT_PAUSE, for: .normal)
        } else {
            controlButton.setTitle(PlayerViewController.BUTTON_TEXT_PLAY, for: .normal)
        }
    }

    private func updateSongInformation(withInfo info: AudioInfoModel) {
        artistLabel.text = info.artist
        titleLabel.text = info.title
        albumLabel.text = info.album
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
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

