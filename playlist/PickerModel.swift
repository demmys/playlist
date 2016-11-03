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
    private let _delegate: PickerModelDelegate

    init(delegate: PickerModelDelegate) {
        _delegate = delegate
    }

    func factory() -> MPMediaPickerController {
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        return picker
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        _delegate.didPickFinish(collection: mediaItemCollection)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        _delegate.didPickCancel()
    }
}
