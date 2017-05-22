//
//  MusicCollection.swift
//  playlist
//
//  Created by 出水　厚輝 on 2017/05/21.
//  Copyright © 2017年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MusicCollection {
    var sectionCount: Int { get }
    var sectionTitles: [String]? { get }

    func itemCountOfSection(atIndex index: Int) -> Int
    func get(atIndex index: Int) -> Music
}
