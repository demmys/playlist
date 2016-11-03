//
//  PickerModelDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/03.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

protocol PickerModelDelegate {
    func didPickFinish(collection: MPMediaItemCollection)
    func didPickCancel()
}
