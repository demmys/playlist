//
//  RemoteControlModelDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/03.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation

protocol RemoteControlModelDelegate : class {
    func didReceivePlay()
    func didReceivePause()
    func didReceiveTogglePlay()
    func didReceiveNext()
    func didReceivePrev()
}
