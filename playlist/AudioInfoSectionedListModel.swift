//
//  AudioInfoListModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/23.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class AudioInfoSectionedListModel {
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
    
    var items: [MPMediaItem] {
        return _collections.reduce([]) { (items, collection) in
            items + collection.items
        }
    }
    
    init<ComparableType: Comparable>(fromQuery query: MPMediaQuery, sortByProperties properties: [String], usingConverter converter: @escaping (Any) -> ComparableType?, ascending: Bool = true) {
        if let collections = query.collections {
            _collections = collections.sorted(by: collectionComparator(forProperties: properties, usingConverter: converter))
        }
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
    
    func getMediaItem(index: Int) -> MPMediaItem? {
        guard 0 <= index && index < _collections.count else {
            return nil
        }
        guard let item = _collections[index].representativeItem else {
            return nil
        }
        return item
    }
    
    func getMediaItem(atIndex itemIndex: Int, inSection sectionIndex: Int) -> MPMediaItem? {
        let itemSection = _collectionSections[sectionIndex]
        guard 0 <= itemIndex && itemIndex < itemSection.range.length else {
            return nil
        }
        return getMediaItem(index: itemSection.range.location + itemIndex)
    }
    
    func getMediaItemArray(atIndex index: Int) -> [MPMediaItem] {
        return _collections[index].items
    }

    func get(atIndex index: Int) -> AudioInfoModel {
        return forceBuildAudioInfo(fromItemOfIndex: index)
    }
    func get(inSection sectionIndex: Int, index: Int) -> AudioInfoModel {
        return forceBuildAudioInfo(fromItemOfIndex: index, inSection: sectionIndex)
    }
    
    func buildAudioInfo(fromItemOfIndex index: Int) -> AudioInfoModel? {
        guard let item = getMediaItem(index: index) else {
            return nil
        }
        return AudioInfoModel(ofItem: item)
    }
    func buildAudioInfo(fromItemOfIndex itemIndex: Int, inSection sectionIndex: Int) -> AudioInfoModel? {
        guard let item = getMediaItem(atIndex: itemIndex, inSection: sectionIndex) else {
            return nil
        }
        return AudioInfoModel(ofItem: item)
    }
    
    func forceBuildAudioInfo(fromItemOfIndex index: Int) -> AudioInfoModel {
        guard let info = buildAudioInfo(fromItemOfIndex: index) else {
            return AudioInfoModel.EmptyAudioInfo
        }
        return info
    }
    func forceBuildAudioInfo(fromItemOfIndex itemIndex: Int, inSection sectionIndex: Int) -> AudioInfoModel {
        guard let info = buildAudioInfo(fromItemOfIndex: itemIndex, inSection: sectionIndex) else {
            return AudioInfoModel.EmptyAudioInfo
        }
        return info
    }
    
    private func collectionComparator<ComparableType: Comparable>(forProperties properties: [String], usingConverter converter: @escaping (Any) -> ComparableType?) -> (MPMediaItemCollection, MPMediaItemCollection) -> Bool {
        return { (leftCollection, rightCollection) in
            for property in properties {
                guard let leftValue = leftCollection.representativeItem?.value(forKey: property) else {
                    return false
                }
                guard let left = converter(leftValue) else {
                    return false
                }
                guard let rightValue = rightCollection.representativeItem?.value(forKey: property) else {
                    return true
                }
                guard let right = converter(rightValue) else {
                    return true
                }
                guard left != right else {
                    continue
                }
                return left < right
            }
            return true
        }
    }
}
