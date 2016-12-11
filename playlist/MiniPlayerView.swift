//
//  MiniPlayerView.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/11.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class MiniPlayerView : UIView, PlaylistManagerModelDelegate {
    private static let BUTTON_TEXT_PLAY = "▶"
    private static let BUTTON_TEXT_PAUSE = "ⅠⅠ"

    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        effectView.frame = bounds
        addSubview(effectView)
        sendSubview(toBack: effectView)
        
        controlButton.addTarget(self, action: #selector(controlButtonDidTouch), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTouch), for: .touchUpInside)
    }

    /*
     * Interface Builder callbacks
     */
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
    
    /*
     * PlaylistManagerModelDelegate
     */
    func playingItemDidChange(info: AudioInfoModel) {
        updateSongInformation(withInfo: info)
    }
    
    func playingItemDidElapse(currentTime: TimeInterval, wholeDuration: TimeInterval) {}
    
    func playlistDidFinish() {
        isHidden = true
    }
    
    func didPlay() {
        updateControlButtonView(playing: true)
    }
    
    func didPause() {
        updateControlButtonView(playing: false)
    }

    /*
     * Control methods
     */
    func present() {
        isHidden = false
        if let playlist = PlayerService.shared.playlist {
            playlist.addDelegate(self)
        }
    }
    
    /*
     * Helper methods
     */
    private func updateSongInformation(withInfo info: AudioInfoModel) {
        titleLabel.text = info.title
        artworkImage.image = info.artworkImage(ofSize: artworkImage.bounds.size)
    }

    private func updateControlButtonView(playing: Bool) {
        if playing {
            controlButton.setTitle(MiniPlayerView.BUTTON_TEXT_PAUSE, for: .normal)
        } else {
            controlButton.setTitle(MiniPlayerView.BUTTON_TEXT_PLAY, for: .normal)
        }
    }
}
