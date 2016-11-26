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
    
    var itemCount: Int {
        return _collections.count
    }
    
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
    
    func pairedItemCountOfSection(atIndex index: Int) -> Int {
        return Int(ceil(Float(_collectionSections[index].range.length) / 2))
    }
    
    func get(inSection sectionIndex: Int, index: Int) -> AudioInfoModel {
        return forceBuildAudioInfo(fromItemOfIndex: index, inSection: sectionIndex)
    }
    
    func getPair(inSection sectionIndex: Int, index: Int) -> (AudioInfoModel, AudioInfoModel?) {
        let firstInfo = forceBuildAudioInfo(fromItemOfIndex: index * 2, inSection: sectionIndex)
        guard let secondInfo = buildAudioInfo(fromItemOfIndex: index * 2 + 1, inSection: sectionIndex) else {
            return (firstInfo, nil)
        }
        return (firstInfo, secondInfo)
    }
    
    private func buildAudioInfo(fromItemOfIndex itemIndex: Int, inSection sectionIndex: Int) -> AudioInfoModel? {
        let itemSection = _collectionSections[sectionIndex]
        guard 0 <= itemIndex && itemIndex < itemSection.range.length else {
            return nil
        }
        let index = itemSection.range.location + itemIndex
        let collection = _collections[index]
        guard let item = collection.representativeItem else {
            return nil
        }
        let playlist = (collection as? MPMediaPlaylist)?.name
        return AudioInfoModel(ofItem: item, withInPlaylist: playlist)
    }
    
    private func forceBuildAudioInfo(fromItemOfIndex itemIndex: Int, inSection sectionIndex: Int) -> AudioInfoModel {
        guard let info = buildAudioInfo(fromItemOfIndex: itemIndex, inSection: sectionIndex) else {
            return AudioInfoModel.EmptyAudioInfo
        }
        return info
    }
}
