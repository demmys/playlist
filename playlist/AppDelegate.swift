//
//  AppDelegate.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/10/25.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let tabBarController = self.window!.rootViewController as! UITabBarController
        let tabBar = tabBarController.tabBar as UITabBar
        let tabBarItemArtist = tabBar.items![0] as UITabBarItem
        let tabBarItemAlbum = tabBar.items![1] as UITabBarItem
        let tabBarItemSong = tabBar.items![2] as UITabBarItem
        let tabBarItemPlaylist = tabBar.items![3] as UITabBarItem
        tabBar.tintColor = UIColor(displayP3Red: 231 / 255, green: 165 / 255, blue: 201 / 255, alpha: 1)
        tabBarItemArtist.image = UIImage(named: "InactiveArtistIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemAlbum.image = UIImage(named: "InactiveAlbumIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemSong.image = UIImage(named: "InactiveSongIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemPlaylist.image = UIImage(named: "InactivePlaylistIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemArtist.selectedImage = UIImage(named: "ArtistIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemAlbum.selectedImage = UIImage(named: "AlbumIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemSong.selectedImage = UIImage(named: "SongIcon")?.withRenderingMode(.alwaysOriginal)
        tabBarItemPlaylist.selectedImage = UIImage(named: "PlaylistIcon")?.withRenderingMode(.alwaysOriginal)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
