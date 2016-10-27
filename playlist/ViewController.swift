//
//  ViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    let BUTTON_TEXT_PLAY = "▶"
    let BUTTON_TEXT_STOP = "■"
    
    // Interface Builder objects
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var playerModel: PlayerModel!
    var pickerModel: PickerModel!

    /*
     * Lifecycle callbacks
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.addTarget(self, action: #selector(selectButtonTouched), for: .touchUpInside)
        controlButton.addTarget(self, action: #selector(controlButtonTouched), for: .touchUpInside)
        
        playerModel = PlayerModel()
        playerModel.setOnItemChanged(observer: playingItemChanged)
        
        pickerModel = PickerModel()
        pickerModel.setOnPickFinished(observer: itemsSelected)
        pickerModel.setOnPickCanceled(observer: itemSelectCanceled)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
     * Interface Builder callbacks
     */
    @objc func selectButtonTouched(_ sender: AnyObject) {
        presentPicker()
    }
    
    @objc func controlButtonTouched(_ sender: AnyObject) {
        print("called controlButtonTouched")
        if playerModel.toggle() {
            controlButton.setTitle(BUTTON_TEXT_STOP, for: .normal)
        } else {
            controlButton.setTitle(BUTTON_TEXT_PLAY, for: .normal)
        }
    }
    
    /*
     * Model callbacks
     */
    private func playingItemChanged(_ item: MPMediaItem?) {
        if let i = item {
            updateSongInformation(item: i)
        }
    }
    
    private func itemsSelected(_ collection: MPMediaItemCollection) {
        playerModel.setQueue(collection: collection)
        if let item = collection.items.first {
            updateSongInformation(item: item)
        }
        dismissPicker()
    }
    
    private func itemSelectCanceled() {
        dismissPicker()
    }
    
    /*
     * View control methods
     */
    private func presentPicker() {
        print("presentPickerCalled.")
        present(pickerModel.factory(), animated: true, completion: nil)
    }
    
    private func dismissPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSongInformation(item: MPMediaItem) {
        artistLabel.text = item.artist ?? "(unknown artist)"
        titleLabel.text = item.title ?? "(unknown title)"
        albumLabel.text = item.albumTitle ?? "(unknown album)"
        if let artwork = item.artwork {
            artworkView.image = artwork.image(at: artworkView.bounds.size)
        } else {
            artworkView.image = nil
            artworkView.backgroundColor = UIColor.gray
        }
    }
}

