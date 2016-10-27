//
//  Picker.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/26.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PickerModel : NSObject, MPMediaPickerControllerDelegate {
    private var _onPickFinishedObserver: ((MPMediaItemCollection) -> Void)?
    private var _onPickCanceledObserver: ((Void) -> Void)?
    
    func factory() -> MPMediaPickerController {
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        return picker
    }
    
    func setOnPickFinished(observer: @escaping (MPMediaItemCollection) -> Void) {
        _onPickFinishedObserver = observer
    }
    
    func setOnPickCanceled(observer: @escaping (Void) -> Void) {
        _onPickCanceledObserver = observer
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        if let observer = _onPickFinishedObserver {
            observer(mediaItemCollection)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        if let observer = _onPickCanceledObserver {
            observer()
        }
    }
}
