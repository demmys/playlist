//
//  AudioInfoSectionedAndPairedListModel.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/05.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class AudioInfoSectionedAndPairedListModel : AudioInfoSectionedListModel {
    var pairedItemCount: Int {
        return Int(ceil(Float(itemCount) / 2))
    }
    
    override init<ComparableType: Comparable>(fromQuery query: MPMediaQuery, sortByProperties properties: [String], usingConverter converter: @escaping (Any) -> ComparableType?, ascending: Bool = true) {
        super.init(fromQuery: query, sortByProperties: properties, usingConverter: converter)
    }
    
    override init(fromQuery query: MPMediaQuery) {
        super.init(fromQuery: query)
    }
    
    func pairedItemCountOfSection(atIndex index: Int) -> Int {
        return Int(ceil(Float(itemCountOfSection(atIndex: index)) / 2))
    }
    
    func getPair(atIndex index: Int) -> (AudioInfoModel, AudioInfoModel?) {
        let firstInfo = forceBuildAudioInfo(fromItemOfIndex: index * 2)
        guard let secondInfo = buildAudioInfo(fromItemOfIndex: index * 2 + 1) else {
            return (firstInfo, nil)
        }
        return (firstInfo, secondInfo)
    }
    func getPair(inSection sectionIndex: Int, index: Int) -> (AudioInfoModel, AudioInfoModel?) {
        let firstInfo = forceBuildAudioInfo(fromItemOfIndex: index * 2, inSection: sectionIndex)
        guard let secondInfo = buildAudioInfo(fromItemOfIndex: index * 2 + 1, inSection: sectionIndex) else {
            return (firstInfo, nil)
        }
        return (firstInfo, secondInfo)
    }
}
