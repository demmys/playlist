//
//  MediaQueryMusicCollection.swift
//  playlist
//
//  Created by 出水　厚輝 on 2017/05/21.
//  Copyright © 2017年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaQueryMusicCollection : MusicCollection {
    private var _collections: [MPMediaItemCollection] = []
    private var _collectionSections: [MPMediaQuerySection] = []
    private var _sectionTitles: [String]?

    init(fromQuery query: MPMediaQuery) {
        if let collections = query.collections {
            _collections = collections
        }
        if let collectionSections = query.collectionSections {
            _collectionSections = collectionSections
            _sectionTitles = collectionSections.map { section in section.title }
        }
    }

    var sectionCount: Int {
        return _collectionSections.count
    }
    var sectionTitles: [String]? {
        return _sectionTitles
    }
    
    func itemCountOfSection(atIndex index: Int) -> Int {
        return _collectionSections[index].range.length
    }
    
    func get(inSection sectionIndex: Int, index: Int) -> Music {
        let itemSection = _collectionSections[sectionIndex]
        guard 0 <= index && index < itemSection.range.length else {
            return Music()
        }
        guard let item = _collections[index].representativeItem else {
            return Music()
        }
        return Music(withItem: item)
    }
}
