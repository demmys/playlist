//
//  MediaQueryBuilder.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/26.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaQueryBuilder {
    static func artists() -> MPMediaQuery {
        let query = MPMediaQuery()
        query.addFilterPredicate(musicPredicate())
        query.addFilterPredicate(notCloudItemPredicate())
        query.groupingType = .albumArtist
        return query
    }

    static func albums() -> MPMediaQuery {
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(notCloudItemPredicate())
        return query
    }
    static func albums(ofArtist artist: String) -> MPMediaQuery {
        let query = albums()
        query.addFilterPredicate(albumArtistPredicate(artist))
        return query
    }
    
    static func songs() -> MPMediaQuery {
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(notCloudItemPredicate())
        return query
    }
    static func songs(inAlbum album: String, ofArtist artist: String) -> MPMediaQuery {
        let query = songs()
        query.addFilterPredicate(albumArtistPredicate(artist))
        query.addFilterPredicate(albumPredicate(album))
        return query
    }
    
    static func playlist() -> MPMediaQuery {
        return MPMediaQuery.playlists()
    }
    
    static private func musicPredicate() -> MPMediaPredicate {
        return MPMediaPropertyPredicate(value: MPMediaType.music.rawValue, forProperty: MPMediaItemPropertyMediaType)
    }
    
    static private func notCloudItemPredicate() -> MPMediaPredicate {
        return MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
    }
    
    static private func albumArtistPredicate(_ artist: String) -> MPMediaPredicate {
        return MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyAlbumArtist)
    }
    
    static private func albumPredicate(_ album: String) -> MPMediaPredicate {
        return MPMediaPropertyPredicate(value: album, forProperty: MPMediaItemPropertyAlbumTitle)
    }
}
