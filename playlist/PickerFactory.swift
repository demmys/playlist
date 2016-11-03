//
//  Picker.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/26.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class PickerFactory : NSObject, MPMediaPickerControllerDelegate {
    private weak var _delegate: PickerFactoryDelegate?

    init(delegate: PickerFactoryDelegate) {
        _delegate = delegate
    }

    func build() -> MPMediaPickerController {
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        return picker
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        _delegate?.didPickFinish(collection: mediaItemCollection)
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        _delegate?.didPickCancel()
    }
}
