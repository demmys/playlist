//
//  WeakArray.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/10.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation

private struct PlaylistManagerModelDelegateWeakElement {
    weak var element: PlaylistManagerModelDelegate?
    var isPresent: Bool {
        return element != nil
    }
}

class PlaylistManagerModelDelegateWeakArray : Sequence {
    private var elements: [PlaylistManagerModelDelegateWeakElement] = []
    
    func makeIterator() -> AnyIterator<PlaylistManagerModelDelegate> {
        var index = 0
        return AnyIterator {
            while index < self.elements.count {
                defer {
                    index += 1
                }
                guard let element = self.elements[index].element else {
                    continue
                }
                return element
            }
            return nil
        }
    }
    
    func append(_ newElement: PlaylistManagerModelDelegate) {
        clean()
        elements.append(PlaylistManagerModelDelegateWeakElement(element: newElement))
    }
    
    private func clean() {
        var index = 0
        while index < elements.count {
            if elements[index].isPresent {
                index += 1
                continue
            }
            elements.remove(at: index)
        }
    }
}
