//
//  MediaItemSectionalizer.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/06.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class SectionalizedMediaData {
    static let UNKNOWN_SECTION_HEADER = "?"
    
    private var sectionHeaders: [String] = []
    private var sections: [String:[MPMediaItem]] = [:]
    
    init(query: MPMediaQuery) {
        if let collections = query.collections {
            for collection in collections {
                guard let item = collection.representativeItem else {
                    continue
                }
                insertData(item: item)
            }
        }
    }
    
    func insertData(item: MPMediaItem) {
        let header = getSectionHeader(item: item)
        if !sectionHeaders.contains(header) {
            sectionHeaders.append(header)
        }
        if sections[header] != nil {
            sections[header]!.append(item)
        }
    }
    
    func getSectionHeader(item: MPMediaItem) -> String {
        return SectionalizedMediaData.UNKNOWN_SECTION_HEADER
    }
}
