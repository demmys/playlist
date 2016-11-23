//
//  AudioInfoListModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/23.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class AudioInfoListModel {
    private var _collections: [MPMediaItemCollection] = []
    private var _collectionSections: [MPMediaQuerySection] = []
    private var _indexTitles: [String]?
    
    var sectionCount: Int {
        return _collectionSections.count
    }
    
    var indexTitles: [String]? {
        return _indexTitles
    }

    init(fromQuery query: MPMediaQuery) {
        if let collections = query.collections {
            _collections = collections
        }
        if let collectionSections = query.collectionSections {
            _collectionSections = collectionSections
            _indexTitles = collectionSections.map { section in section.title }
        }
    }
    
    func itemCountOfSection(atIndex index: Int) -> Int {
        return _collectionSections[index].range.length
    }
    
    func get(inSection sectionIndex: Int, index: Int) -> AudioInfoModel {
        let itemSection = _collectionSections[sectionIndex]
        let itemIndex = itemSection.range.location + index
        guard itemIndex < _collections.count else {
            return AudioInfoModel.EmptyAudioInfo
        }
        guard let item = _collections[itemIndex].representativeItem else {
            return AudioInfoModel.EmptyAudioInfo
        }
        return AudioInfoModel(ofItem: item)
    }
}
